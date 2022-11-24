import 'dart:io';

import 'package:flutter/material.dart';

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
        // print("Internet Connected");
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/noInternet');
    }
  }
}
