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
    }

    return _database;
  }

  Future<Note?> insertEntry(Note note) async {
    _database = await openDb();

    final id = await _database?.insert(NoteImpNames.TableName, note.toJson());

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

    await _database!.update(
        NoteImpNames.TableName, {NoteImpNames.pin: !note.pin ? 1 : 0},
        where: '${NoteImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future updateNote(Note note) async {
    final _database = await openDb();

    String apiUrl =
        "https://sharpwebtechnologies.com/KeepNotes/API/editNote.php";

    Response response = await post(
      Uri.parse(apiUrl),
      body: {
        'id': note.id.toString(),
        'user': UserConstant.userEmail.toString(),
        'title': note.title.toString(),
        'content': note.content.toString(),
        'createdTime' : note.createdTime.toIso8601String(),
      },
    );

    await _database!.update(NoteImpNames.TableName, note.toJson(),
        where: '${NoteImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future deleteNote(int? id) async {
    final _database = await openDb();

    await _database!.delete(NoteImpNames.TableName,
        where: '${NoteImpNames.id} = ?', whereArgs: [id]);
  }

  Future DBClose() async {
    final _database = await openDb();
    await _database!.close();
  }
}
