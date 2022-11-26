import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/services/db.dart';
import 'package:keep_notes/services/localDB.dart';
import 'package:keep_notes/include/userConstant.dart';

import '../services/auth.dart';
import '../services/checkInternet.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSignin = true;

  void checkUser() async {
    UserConstant.userName = (await localDataSaver.getName()).toString();
    UserConstant.userEmail = (await localDataSaver.getEmail()).toString();
    UserConstant.userImg = (await localDataSaver.getImg()).toString();

    if (UserConstant.userName != "null") {
      if (UserConstant.userEmail != "null") {
        if (UserConstant.userImg != "null") {
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    }
    showSignin = true;
  }

  void authUser(User isUser) async {
    if (!isUser.isAnonymous) {
      if (isUser.displayName != "") {
        if (isUser.uid != "") {
          print(isUser.displayName);
          UserConstant.userName = (await localDataSaver.getName()).toString();
          UserConstant.userEmail = (await localDataSaver.getEmail()).toString();
          UserConstant.userImg = (await localDataSaver.getImg()).toString();
          setState(() {
            showSignin = false;
          });
          await NotesDatabase().openDb();
          await NotesDatabase().DBClose();
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    }
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Image.asset(
                    'asset/images/launcher.png',
                    width: 180,
                    height: 180,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "KEEP NOTES",
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Write Down Your Thinking And Notes In Keep Notes And Make These Safe And Secure",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          showSignin
              ? Positioned(
                  bottom: 10,
                  child: Center(
                    child: Center(
                        child: SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          await CheckInternet().connectivity(context);
                          User? isUser = await signInWithGoogle();
                          authUser(isUser!);
                        } catch (_) {
                          Fluttertoast.showToast(
                              msg: "Internet Is Not Connected",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(216, 255, 57, 54),
                              textColor: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16.0);
                        }
                      },
                    )),
                  ),
                )
              : SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }
}
