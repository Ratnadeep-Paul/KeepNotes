import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/include/colorMode.dart';
import 'package:keep_notes/include/userConstant.dart';
import 'package:keep_notes/model/notesModel.dart';
import 'package:keep_notes/screen/createNoteView.dart';
import 'package:keep_notes/screen/noteView.dart';
import 'package:keep_notes/screen/sideMenuBar.dart';
import 'package:keep_notes/services/db.dart';
import 'package:keep_notes/services/checkInternet.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  bool listViewStyle = false;
  bool showPinnedNote = false;
  List<Note> allNotes = <Note>[];
  List<Note> allPinnedNotes = <Note>[];
  bool allNoteLoading = true;
  String headingName = "ALL";

  Future readPinnedNotes() async {
    Iterable<Note> notesPinned = await NotesDatabase().readAllNotes();

    allPinnedNotes.clear();
    setState(() {
      for (final notes in notesPinned) {
        if (notes.pin == true) {
          allPinnedNotes.add(notes);
        }
      }
      isPinnedNote();
    });
  }

  isPinnedNote() {
    setState(() {
      if (allPinnedNotes.length > 0) {
        showPinnedNote = true;
      } else {
        showPinnedNote = false;
      }
    });
  }

  Future readAllEnrty() async {
    Iterable<Note> notesIter = await NotesDatabase().readAllNotes();

    allNotes.clear();
    setState(() {
      for (final note in notesIter) {
        allNotes.add(note);
      }
      allNoteLoading = false;
      headingName = "ALL";
      readPinnedNotes();
    });
  }

  searchNote(String keyword) async {
    allNotes.clear();

    setState(() {
      showPinnedNote = false;
      allNoteLoading = true;
    });

    final resultIds = await NotesDatabase().getNoteString(keyword);

    resultIds.forEach((element) async {
      allNotes.add(element);
    });

    setState(() {
      allNoteLoading = false;
      headingName = "Result";
    });
  }

  late FocusNode focusNode;
  void showKeyboard() {
    focusNode.requestFocus();
  }

  void dismissKeyboard() {
    focusNode.unfocus();
  }

  @override
  void initState() {
    CheckInternet().connectivity(context);
    focusNode = FocusNode();
    readAllEnrty();
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
    return GestureDetector(
      onTap: () => dismissKeyboard(),
      child: Scaffold(
        backgroundColor: bgColor,
        key: drawerKey,
        endDrawerEnableOpenDragGesture: true,
        drawer: SideMenuBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateNoteView()));
          },
          backgroundColor: Colors.blue[400],
          elevation: 1.0,
          child: Icon(
            Icons.add,
            size: 40,
            color: black,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    // Top Section
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10),
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          IconButton(
                              selectedIcon: Icon(
                                  color: white.withOpacity(0.8),
                                  Icons.menu_open_outlined),
                              highlightColor: black.withOpacity(0.6),
                              focusColor: black.withOpacity(0.6),
                              onPressed: () {
                                drawerKey.currentState!.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu_rounded,
                                color: white,
                              )),
                          Container(
                              // Search Container
                              margin: EdgeInsets.only(left: 5),
                              // height: 55,
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      if (value == "" || value == null) {
                                        readAllEnrty();
                                      } else {
                                        searchNote(value
                                            .toLowerCase()
                                            .replaceAll(" ", ""));
                                      }
                                    },
                                    autofocus: false,
                                    onTap: (() => showKeyboard()),
                                    focusNode: focusNode,
                                    textInputAction: TextInputAction.search,
                                    style: TextStyle(
                                        color: white.withOpacity(0.6),
                                        fontSize: 16),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: "Search Your Notes",
                                      hintStyle: TextStyle(
                                          color: white.withOpacity(0.6),
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )),
                        ]),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  white.withOpacity(0.2)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      if (listViewStyle) {
                                        listViewStyle = false;
                                      } else {
                                        listViewStyle = true;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    listViewStyle
                                        ? Icons.view_agenda_outlined
                                        : Icons.grid_view_outlined,
                                    color: white,
                                  )),
                              CircleAvatar(
                                radius: 16,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(UserConstant.userImg)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    // Notes Container
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: <Widget>[
                        showPinnedNote
                            ? listViewStyle
                                ? listPinnedNotesSection()
                                : allPinnedNotesSection()
                            : SizedBox(
                                height: 0,
                              ),
                        listViewStyle ? listNotesSection() : allNotesSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget allNotesSection() {
    return Column(
      children: [
        // ----- Top Bar Ends -----
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 10, left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingName,
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: white.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        allNoteLoading
            ? Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  color: cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      backgroundColor: bgColor,
                      color: cardColor,
                    ),
                  ),
                ),
              )
            : Container(
                child: StaggeredGridView.countBuilder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allNotes.length,
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NoteView(note: allNotes[index])))
                          .then((value) => readAllEnrty());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: cardMultiColor[allNotes[index].background],
                          border: Border.all(color: white.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allNotes[index].title,
                            style: GoogleFonts.varelaRound(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            allNotes[index].content.length > 200
                                ? "${allNotes[index].content.substring(0, 200)}..."
                                : allNotes[index].content,
                            style: GoogleFonts.poppins(
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget listNotesSection() {
    return Column(
      children: [
        // ----- Top Bar Ends -----
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 10, left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingName,
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: white.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        allNoteLoading
            ? Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  color: cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      backgroundColor: bgColor,
                      color: cardColor,
                    ),
                  ),
                ),
              )
            : Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NoteView(note: allNotes[index])))
                          .then((value) => readAllEnrty());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: cardMultiColor[allNotes[index].background],
                          border: Border.all(color: white.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allNotes[index].title,
                            style: GoogleFonts.varelaRound(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            allNotes[index].content.length > 200
                                ? "${allNotes[index].content.substring(0, 200)}..."
                                : allNotes[index].content,
                            style: GoogleFonts.poppins(
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget allPinnedNotesSection() {
    return Column(
      children: [
        // ----- Top Bar Ends -----
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 10, left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PINNED NOTES",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: white.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        allNoteLoading
            ? Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  color: cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      backgroundColor: bgColor,
                      color: cardColor,
                    ),
                  ),
                ),
              )
            : Container(
                child: StaggeredGridView.countBuilder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allPinnedNotes.length,
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NoteView(note: allPinnedNotes[index])))
                          .then((value) => readAllEnrty());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color:
                              cardMultiColor[allPinnedNotes[index].background],
                          border: Border.all(color: white.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allPinnedNotes[index].title,
                            style: GoogleFonts.varelaRound(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            allPinnedNotes[index].content.length > 200
                                ? "${allPinnedNotes[index].content.substring(0, 200)}..."
                                : allPinnedNotes[index].content,
                            style: GoogleFonts.poppins(
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget listPinnedNotesSection() {
    return Column(
      children: [
        // ----- Top Bar Ends -----
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 10, left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PINNED NOTES",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: white.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        allNoteLoading
            ? Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  color: cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      backgroundColor: bgColor,
                      color: cardColor,
                    ),
                  ),
                ),
              )
            : Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: allPinnedNotes.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NoteView(note: allPinnedNotes[index])))
                          .then((value) => readAllEnrty());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color:
                              cardMultiColor[allPinnedNotes[index].background],
                          border: Border.all(color: white.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allPinnedNotes[index].title,
                            style: GoogleFonts.varelaRound(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            allPinnedNotes[index].content.length > 200
                                ? "${allPinnedNotes[index].content.substring(0, 200)}..."
                                : allPinnedNotes[index].content,
                            style: GoogleFonts.poppins(
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
