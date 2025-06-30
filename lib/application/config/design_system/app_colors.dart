import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff815FF9);
  static const Color primaryDarkColor = Color(0xff131138);
  static const Color primaryYellow = Color(0xffe59f25);
  static const Color primaryOrange = Color(0xffE99627);
  static const Color primaryRed = Color(0xffF34848);
  static const Color primaryGrey = Color(0xffbfbfbf);
  static const Color primaryLiteGrey = Color(0xffF7F7F7);
  static const Color primaryDarkGrey = Color(0xffA0A0A0);
  static const Color borderGrey = Color(0xffE6E6E6);
  static const Color primaryWhite = Color(0xffffffff);
  static const Color primaryBlack = Color(0xff000000);
  static const Color errorColor = Color(0xffFF0000);
  static const Color pendingColor = Color(0xFFE76F51);
  static const Color textFieldColor = Color(0xFF1E1E1E);
  static const Color scaffoldColor = Color(0xFFF3F3F3);

  static Color get lighterPrimaryColor {
    return Color.lerp(primaryColor, Colors.white, 0.8)!;
  }
}
