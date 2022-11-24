import 'package:keep_notes/include/color.dart';
import 'package:keep_notes/include/userConstant.dart';
import 'package:keep_notes/services/localDB.dart';

class ColorMode {
  static String mode = UserConstant.userMode;

  setModeDb(bool isDarkMode) async {
    if (isDarkMode) {
      mode = "Dark";
      localDataSaver.saveMode("Dark");
    } else {
      mode = "Light";
      localDataSaver.saveMode("Light");
    }
  }

  getMode() async {
    if (mode == "") {
      mode = (await localDataSaver.getMode()).toString();
      UserConstant.userMode = mode;
    } else {
      mode = mode;
    }
  }

  modeChanger() async {
    await getMode();

    if (mode == "Dark") {
      bgColor = bgColor_dark;
      cardColor = cardColor_dark;
      white = white_dark;
      black = black_dark;
      cardMultiColor = cardMultiColor_dark;
    } else {
      bgColor = bgColor_light;
      cardColor = cardColor_light;
      white = white_light;
      black = black_light;
      cardMultiColor = cardMultiColor_light;
    }
  }
}
