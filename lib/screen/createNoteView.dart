import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/model/notesModel.dart';
import 'package:keep_notes/services/db.dart';

import '../include/color.dart';
import '../include/colorMode.dart';
import '../services/checkInternet.dart';
import 'home.dart';

class CreateNoteView extends StatefulWidget {
  CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();
  bool loading = false;

  closeDb() async {
    await NotesDatabase().DBClose();
  }

  @override
  void dispose() {
    closeDb();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    CheckInternet().connectivity(context);
    ColorMode().modeChanger();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () async {
                await CheckInternet().connectivity(context);
                setState(() {
                  loading = true;
                });
                Note aNote = Note(
                    title: titleController.text,
                    content: contentController.text,
                    pin: false,
                    createdTime: DateTime.now(),
                    background: 0);
                await NotesDatabase().insertEntry(aNote);

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
                setState(() {
                  loading = false;
                });
              },
              icon: Icon(color: white.withOpacity(0.8), Icons.save_rounded))
        ],
      ),
      body: loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              color: bgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: white.withOpacity(0.7),
                    color: cardColor,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      cursorColor: white,
                      style: GoogleFonts.varelaRound(
                          color: white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Title",
                          hintStyle: GoogleFonts.varelaRound(
                              color: Colors.grey.withOpacity(0.8),
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                        child: TextField(
                      controller: contentController,
                      keyboardType: TextInputType.multiline,
                      minLines: 10,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(height: 1.6),
                          color: white.withOpacity(0.8),
                          fontSize: 15),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Write Your Note",
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                              fontSize: 15)),
                    )),
                  ],
                ),
              ),
            ),
    );
  }
}
