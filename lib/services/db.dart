import 'dart:convert';
import 'dart:io';
import 'localDB.dart';
import 'package:keep_notes/include/userConstant.dart';
import 'package:keep_notes/model/notesModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart';

class NotesDatabase {
  static final NotesDatabase _notesDatabase = NotesDatabase._internal();
  static sql.Database? _database;

  factory NotesDatabase() {
    return _notesDatabase;
  }

  NotesDatabase._internal();

  Future<sql.Database?> openDb() async {
    _database =
        await sql.openDatabase(join(await sql.getDatabasesPath(), "Notes.db"));

    final idType = 'INTEGER PRIMARY KEY UNIQUE';
    final boolType = 'BOOLEAN';
    final textType = 'TEXT';

    try {
      await _database?.query('${NoteImpNames.TableName}');
    } catch (e) {
      await _database?.execute('''
          CREATE TABLE ${NoteImpNames.TableName} (
          ${NoteImpNames.id} $idType, 
          ${NoteImpNames.title} $textType, 
          ${NoteImpNames.content} $textType, 
          ${NoteImpNames.pin} $boolType, 
          ${NoteImpNames.createdTime} $textType,
          ${NoteImpNames.background} $textType
          )''');

      String apiUrl =
          "https://sharpwebtechnologies.com/KeepNotes/API/allNote.php";

      Map response_notes = {};
      Response response = await post(
        Uri.parse(apiUrl),
        body: {
          'user': UserConstant.userEmail.toString(),
        },
      );
      response_notes = jsonDecode(response.body);

      for (int i = 0; i < response_notes["id"].length; i++) {
        Note aNote = Note(
            id: int.parse(response_notes["id"][i]),
            title: response_notes["title"][i].toString(),
            content: response_notes["content"][i].toString(),
            pin: response_notes["pin"][i] == 1,
            createdTime: DateTime.parse(response_notes["createdTime"][i]),
            background: int.parse(response_notes["background"][i]));

        await _database?.insert(NoteImpNames.TableName, aNote.toJson());
      }
    }

    return _database;
  }

  Future<Note?> insertEntry(Note note) async {
    _database = await openDb();

    final id = await _database?.insert(NoteImpNames.TableName, note.toJson());

    try {
      String apiUrl =
          "https://sharpwebtechnologies.com/KeepNotes/API/createNote.php";

      Response response = await post(
        Uri.parse(apiUrl),
        body: {
          'id': id.toString(),
          'title': note.title.toString(),
          'content': note.content.toString(),
          'pin': (note.pin ? 1 : 0).toString(),
          'createdTime': note.createdTime.toIso8601String(),
          'background': note.background.toString(),
          'user': UserConstant.userEmail.toString(),
        },
      );
    } catch (e) {
      await localDataSaver.saveAction("true");
    }

    return note.copy(id: id);
  }

  Future<Note?> readOneNote(int id) async {
    final _database = await openDb();
    final oneNote = await _database!.query(NoteImpNames.TableName,
        columns: NoteImpNames.values,
        where: '${NoteImpNames.id} = ?',
        whereArgs: [id]);

    return oneNote.map((json) => Note.fromJson(json)).first;
  }

  Future<Iterable<Note>> readAllNotes() async {
    final _database = await openDb();
    final orderBy = '${NoteImpNames.createdTime} DESC';
    final query_result =
        await _database?.query(NoteImpNames.TableName, orderBy: orderBy);
    return query_result!.map((json) => Note.fromJson(json));
  }

  Future<Iterable<Note>> getNoteString(String query) async {
    String NoteText = "";
    final _database = await openDb();
    final orderBy = '${NoteImpNames.createdTime} DESC';
    final result = await _database?.query(NoteImpNames.TableName,
        orderBy: orderBy,
        where:
            'LOWER(title) LIKE "%$query%" OR LOWER(content) LIKE "%$query%"');

    return result!.map((json) => Note.fromJson(json));
  }

  Future pinNote(Note note) async {
    final _database = await openDb();

    try {
      String apiUrl =
          "https://sharpwebtechnologies.com/KeepNotes/API/pinNote.php";

      Response response = await post(
        Uri.parse(apiUrl),
        body: {
          'id': note.id.toString(),
          'pin': (!note.pin ? 1 : 0).toString(),
          'user': UserConstant.userEmail.toString(),
        },
      );
    } catch (e) {
      await localDataSaver.saveAction("true");
    }

    await _database!.update(
        NoteImpNames.TableName, {NoteImpNames.pin: !note.pin ? 1 : 0},
        where: '${NoteImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future updateNote(Note note) async {
    final _database = await openDb();

    try {
      String apiUrl =
          "https://sharpwebtechnologies.com/KeepNotes/API/editNote.php";

      Response response = await post(
        Uri.parse(apiUrl),
        body: {
          'id': note.id.toString(),
          'user': UserConstant.userEmail.toString(),
          'title': note.title.toString(),
          'content': note.content.toString(),
          'createdTime': note.createdTime.toIso8601String(),
        },
      );
    } catch (e) {
      await localDataSaver.saveAction("true");
    }

    await _database!.update(NoteImpNames.TableName, note.toJson(),
        where: '${NoteImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future deleteNote(int? id) async {
    final _database = await openDb();

    try {
      String apiUrl =
          "https://sharpwebtechnologies.com/KeepNotes/API/deleteNote.php";

      Response response = await post(
        Uri.parse(apiUrl),
        body: {
          'id': id.toString(),
          'user': UserConstant.userEmail.toString(),
        },
      );
    } catch (e) {
      await localDataSaver.saveAction("true");
    }

    await _database!.delete(NoteImpNames.TableName,
        where: '${NoteImpNames.id} = ?', whereArgs: [id]);
  }

  Future DBClose() async {
    final _database = await openDb();
    await _database!.close();
  }
}
