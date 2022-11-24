import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/screen/editNoteView.dart';
import 'package:keep_notes/screen/home.dart';
import '../include/colorMode.dart';
import '../include/userConstant.dart';
import '../model/notesModel.dart';
import '../services/checkInternet.dart';
import '../services/db.dart';

class NoteView extends StatefulWidget {
  Note note;
  NoteView({required this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final allColors = cardMultiColor;
  int numColor = 0;
  late bool pinned;
  bool loading = false;

  setBackground(int colorNum) async {
    await CheckInternet().connectivity(context);

    setState(() {
      loading = true;
      numColor = colorNum;
    });

    String apiUrl =
        "https://sharpwebtechnologies.com/KeepNotes/API/backgroundNote.php";

    Response response = await post(
      Uri.parse(apiUrl),
      body: {
        'id': widget.note.id.toString(),
        'background': colorNum.toString(),
        'user': UserConstant.userEmail.toString(),
      },
    );

    await NotesDatabase().updateNote(Note(
        id: widget.note.id,
        title: widget.note.title,
        content: widget.note.content,
        pin: widget.note.pin,
        createdTime: widget.note.createdTime,
        background: colorNum));

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    CheckInternet().connectivity(context);
    numColor = widget.note.background;
    pinned = widget.note.pin;
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
      backgroundColor: cardMultiColor[numColor],
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                color: white.withOpacity(0.8),
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context, ['true']);
              },
            );
          },
        ),
        backgroundColor: cardMultiColor[numColor],
        elevation: 0.0,
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () async {
                CheckInternet().connectivity(context);

                setState(() {
                  pinned = !pinned;
                  loading = true;
                });

                await NotesDatabase().pinNote(Note(
                    id: widget.note.id,
                    title: widget.note.title,
                    content: widget.note.content,
                    pin: !pinned,
                    createdTime: widget.note.createdTime,
                    background: numColor));

                setState(() {
                  loading = false;
                });
              },
              icon: pinned
                  ? Icon(color: white.withOpacity(0.8), Icons.push_pin_rounded)
                  : Icon(
                      color: white.withOpacity(0.8), Icons.push_pin_outlined)),
          IconButton(
              splashRadius: 20,
              onPressed: () async {
                CheckInternet().connectivity(context);

                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNoteView(
                              note: Note(
                                  id: widget.note.id,
                                  title: widget.note.title,
                                  content: widget.note.content,
                                  pin: widget.note.pin,
                                  createdTime: widget.note.createdTime,
                                  background: numColor),
                            )));
              },
              icon: Icon(
                  color: white.withOpacity(0.8),
                  Icons.mode_edit_outline_outlined)),
          IconButton(
              splashRadius: 20,
              onPressed: () async {
                CheckInternet().connectivity(context);
                setState(() {
                  loading = true;
                });
                await NotesDatabase().deleteNote(widget.note.id);
                setState(() {
                  loading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              icon: Icon(color: white.withOpacity(0.8), Icons.delete_outlined)),
        ],
      ),
      body: loading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200,
              color: cardMultiColor[numColor],
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
          : GestureDetector(
              onLongPress: () async {
                CheckInternet().connectivity(context);

                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNoteView(
                              note: Note(
                                  id: widget.note.id,
                                  title: widget.note.title,
                                  content: widget.note.content,
                                  pin: widget.note.pin,
                                  createdTime: widget.note.createdTime,
                                  background: numColor),
                            )));
              },
              child: Stack(
                children: [
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    top: 0,
                    height: MediaQuery.of(context).size.height - 150,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.note.title,
                              style: GoogleFonts.varelaRound(
                                  color: white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.note.content,
                              style: GoogleFonts.poppins(
                                color: white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 0,
                    right: 0,
                    height: 60,
                    child: Container(
                      color: black.withAlpha(46),
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: ListView.builder(
                          // physics:  NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: allColors.length,
                          itemBuilder: (context, index) => InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              setBackground(index);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: allColors[index],
                                    border: Border.all(
                                        color: white.withOpacity(0.3))),
                                child: Text(" "),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // child: Text("kjhkj;n "),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
