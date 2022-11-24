import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/screen/home.dart';

import '../include/colorMode.dart';
import '../model/notesModel.dart';
import '../services/checkInternet.dart';
import '../services/db.dart';
import 'noteView.dart';

class EditNoteView extends StatefulWidget {
  Note note;
  EditNoteView({required this.note});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  final allColors = cardMultiColor;
  int numColor = 0;
  bool loading = false;

  late String newTitle;
  late String newContent;

  @override
  void initState() {
    CheckInternet().connectivity(context);
    newTitle = widget.note.title;
    newContent = widget.note.content;
    numColor = widget.note.background;
    ColorMode().modeChanger();
    super.initState();
  }

  closeDb() async {
    await NotesDatabase().DBClose();
  }

  @override
  void dispose() {
    closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: allColors[numColor],
      appBar: AppBar(
        backgroundColor: allColors[numColor],
        elevation: 0.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                color: white.withOpacity(0.8),
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoteView(note: widget.note)));
              },
            );
          },
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () async {
                await CheckInternet().connectivity(context);
                setState(() {
                  loading = true;
                });
                Note newNote = Note(
                    id: widget.note.id,
                    title: newTitle,
                    content: newContent,
                    pin: widget.note.pin,
                    createdTime: DateTime.now(),
                    background: numColor);
                await NotesDatabase().updateNote(newNote);

                setState(() {
                  loading = false;
                });

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(color: white.withOpacity(0.8), Icons.save_rounded))
        ],
      ),
      body: loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              color: allColors[numColor],
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
                    Form(
                      child: TextFormField(
                        onChanged: (value) => newTitle = value,
                        initialValue: newTitle,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: white,
                        textInputAction: TextInputAction.next,
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
                              color: white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      child: Form(
                        child: TextFormField(
                          onChanged: (value) => newContent = value,
                          initialValue: newContent,
                          keyboardType: TextInputType.multiline,
                          minLines: 10,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(height: 1.6),
                            color: white,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Write Your Note",
                            hintStyle: GoogleFonts.poppins(
                              color: white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
