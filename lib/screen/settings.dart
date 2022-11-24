import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/include/userConstant.dart';
import 'package:keep_notes/services/localDB.dart';

import '../include/colorMode.dart';
import '../services/checkInternet.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String mode;
  late bool darkMode;

  setMode() {
    mode = ColorMode.mode;
    if (mode == "Dark") {
      darkMode = true;
    } else {
      darkMode = false;
    }
  }

  @override
  void initState() {
    CheckInternet().connectivity(context);
    ColorMode().modeChanger();
    setMode();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  color: white.withOpacity(0.8),
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              );
            },
          ),
          title: Text(
            "Settings",
            style: TextStyle(color: white),
          ),
          backgroundColor: bgColor,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Dark Mode",
                    style: GoogleFonts.varelaRound(
                        color: white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Transform.scale(
                      scale: 1.2,
                      child: Switch.adaptive(
                          value: darkMode,
                          onChanged: (value) {
                            setState(() {
                              ColorMode().setModeDb(value);
                              darkMode = value;
                              ColorMode().modeChanger();
                            });
                          }))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
