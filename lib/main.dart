import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/screen/noInternet.dart';
import 'screen/home.dart';
import 'screen/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    routes: {
      "/login": (context) => Login(),
      "/home": (context) => Home(),
      "/noInternet":(context) => NoInternet(),
    },
  ));
}

// Colors -- Blue, Crimsom Red, White, Gray