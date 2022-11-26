import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:keep_notes/include/userConstant.dart';
import 'package:keep_notes/services/db.dart';
import 'localDB.dart';
import '../model/notesModel.dart';

class CheckInternet {
  Future<bool> isConnected() async {
    bool resultBool = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        resultBool = true;
      }
    } on SocketException catch (_) {
      resultBool = false;
    }
    print(resultBool);
    return resultBool;
  }

  connectivity(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("Internet Connected");
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/noInternet');
    }
  }

  dataSync(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        UserConstant.userAction = (await localDataSaver.getAction()).toString();
        if (UserConstant.userAction == "true") {
          Fluttertoast.showToast(
              msg: "Synchronizing Note.. Please Wait",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(216, 255, 57, 54),
              textColor: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.0);

          String apiUrl =
              "https://sharpwebtechnologies.com/KeepNotes/API/deleteNote.php";

          Response response = await post(
            Uri.parse(apiUrl),
            body: {
              'id': "all",
              'user': UserConstant.userEmail.toString(),
            },
          );

          List<Note> allNotes = <Note>[];
          Iterable<Note> notesIter = await NotesDatabase().readAllNotes();

          allNotes.clear();
          for (final note in notesIter) {
            allNotes.add(note);
          }

          for (var i = 0; i < allNotes.length; i++) {
            String url =
                "https://sharpwebtechnologies.com/KeepNotes/API/createNote.php";

            await post(
              Uri.parse(url),
              body: {
                'id': allNotes[i].id.toString(),
                'title': allNotes[i].title.toString(),
                'content': allNotes[i].content.toString(),
                'pin': (allNotes[i].pin ? 1 : 0).toString(),
                'createdTime': allNotes[i].createdTime.toIso8601String(),
                'background': allNotes[i].background.toString(),
                'user': UserConstant.userEmail.toString(),
              },
            );
          }
          Fluttertoast.showToast(
              msg: "Synchronizing Completed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(215, 74, 54, 255),
              textColor: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.0);
          UserConstant.userAction = "false";
          localDataSaver.saveAction("false");
        }
      }
    } on SocketException catch (_) {
      // print("N");
    }
  }
}
