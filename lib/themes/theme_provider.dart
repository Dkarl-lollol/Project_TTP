import 'package:flutter/material.dart';
import 'package:hellodekal/themes/light_mode.dart';
import 'package:hellodekal/themes/dark_mode.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightmode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if (_themeData == lightmode){
      themeData = darkMode;
    } else {
      themeData = lightmode;
    }
  }
}
