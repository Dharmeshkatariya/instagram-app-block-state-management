import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Color appColor = const Color(0xff53C3D2);
  static Color navyBlue = const Color(0xFF222F3F);
  static Color blue = const Color(0xFF03152A);
  static Color lightBlue = const Color(0xFFC4CFEE);
  static Color black2 = const Color(0xFF000000);
  static Color grey2 = const Color(0xFFF0E7E7);
  static Color blueDark = const Color(0xFF0d00a4);
  static Color grey3 = const Color(0xFF4a4e69);
  static Color darkBlue1 = const Color(0xFF22333b);
  static Color darkGrey = const Color(0xff292e2f);
  static Color darkGrey1 = const Color(0xFF303030);
  static Color red = const Color(0xFFFE4545);

  static const Color white = Color(0xffFFFFFF);
  static const Color lightGrey = Color.fromARGB(255, 232, 232, 232);
  static const Color grey = Color(0xff9E9E9E);
  static const Color transparentGrey = Color(0xbbe3e3e3);

  static const Color customGrey = Color(0xffdcdcdc);
  static const Color customGreyForWeb = Color(0x17eeeee9);
  static const Color appBarElationColor = Color.fromARGB(137, 222, 222, 222);

  static const Color lowOpacityGrey = Color(0x2A3E3E2F);
  static const Color veryLowOpacityGrey = Color(0x16444439);
  static const Color imageGrey = Color(0xFFE1E1E1);

  static const Color black = Color(0xff000000);
  static const Color black87 = Color(0xdd000000);
  static const Color black54 = Color(0x8a000000);
  static const Color black26 = Color(0x42000000);
  static const Color black12 = Color(0x0000001F);
  static const Color darkWhite = Color(0x0bffffff);
  static const Color shimmerDarkGrey = Color(0xFFAFAFAF);
  static const Color shimmerLightGrey = Color(0xFFE5E5E5);

  static const Color lightBlack = Color(0x19242424);
  static const Color darkGray = Color(0xff282828);
  static const Color veryDarkGray = Color(0xff1a1a1a);

  static const Color lightDarkGray = Color(0xff696969);

  static const Color black45 = Colors.black45;
  static const Color black38 = Colors.black38;

  static const Color teal = Color(0xFF009688);
  static const Color green = Colors.green;

  static const Color darkBlue = Color.fromARGB(255, 4, 113, 238);
  static const Color purple = Color.fromARGB(255, 160, 4, 238);
  static const Color transparentBlue = Color(0x86CBE3FA);

  static const Color redAccent = Colors.redAccent;
  static const Color blackRed = Color.fromARGB(255, 182, 14, 14);
  static const Color yellow = Color.fromARGB(255, 252, 219, 3);
  static const Color lightYellow = Color.fromARGB(219, 255, 240, 27);

  static const Color orange = Color.fromARGB(255, 170, 115, 33);

  static const Color transparent = Colors.transparent;

  static InputBorder formDecoration() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.black, width: 0.5));
  }

  static InputBorder errorDecoration() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.red, width: 1));
  }
}
