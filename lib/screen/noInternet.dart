import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/services/checkInternet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../include/colorMode.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  
  chcekConnection() async {
    if (await CheckInternet().isConnected()) {
      Fluttertoast.showToast(
          msg: "Internet Is Now Connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(216, 255, 57, 54),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "Internet Not Connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        backgroundColor: cardColor,
          textColor: white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    ColorMode().modeChanger();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              padding:
                  EdgeInsets.only(top: 140, left: 15, right: 15, bottom: 15),
              width: MediaQuery.of(context).size.width,
              height: 345,
              decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          MediaQuery.of(context).size.width / 2),
                      topRight: Radius.circular(
                          MediaQuery.of(context).size.width / 2))),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "No Internet Connection",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "This Is A Cloud Base Notes Application And It Needs Internet Connection. \n Please Connect To The Internet And Try Again",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.novaRound(
                        textStyle: TextStyle(fontSize: 18, color: white),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () => chcekConnection(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 60,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 255, 133, 62),
                        ),
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.novaRound(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.width - 0,
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width - 50)),
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 20),
              child: Image.asset(
                'asset/images/no-wifi.png',
                width: 250,
                height: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
