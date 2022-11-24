import 'package:flutter/material.dart';
import 'package:keep_notes/include/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/screen/settings.dart';

import '../include/colorMode.dart';
import '../services/checkInternet.dart';

class SideMenuBar extends StatefulWidget {
  SideMenuBar({super.key});

  @override
  State<SideMenuBar> createState() => _SideMenuBarState();
}

class _SideMenuBarState extends State<SideMenuBar> {
  @override
  void initState() {
    CheckInternet().connectivity(context);
    ColorMode().modeChanger();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(color: bgColor),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 18, bottom: 18),
                    child: Text(
                      "Keep Notes",
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              color: white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    )),
                menuItem_1(),
                menuItem_3()
              ]),
        ),
      ),
    );
  }

  Widget menuItem_1() {
    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 5),
      child: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.orangeAccent.withOpacity(0.3)),
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => white.withOpacity(0.2)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              )),
          child: Container(
            padding: EdgeInsets.all(3),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: white.withOpacity(0.7),
                  size: 25,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Notes",
                    style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: white.withOpacity(0.7),
                      fontSize: 16,
                    )))
              ],
            ),
          )),
    );
  }

  Widget menuItem_3() {
    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 5),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          },
          style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all(
              //     Colors.orangeAccent.withOpacity(0.3)),
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => white.withOpacity(0.2)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              )),
          child: Container(
            padding: EdgeInsets.all(3),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: white.withOpacity(0.7),
                  size: 25,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Settings",
                    style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: white.withOpacity(0.7),
                      fontSize: 16,
                    )))
              ],
            ),
          )),
    );
  }
}
