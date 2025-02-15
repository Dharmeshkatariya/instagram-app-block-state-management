import 'package:flutter/material.dart';
import 'package:instagram_dharmesh_bloc_demo/core/colors/app_colors.dart';

import '../constants/constants.dart';
import '../style_resource/custom_textstyle.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: AppColors.white,
      useMaterial3: true,
      primaryColorLight: AppColors.lightGrey,
      primarySwatch: Colors.grey,
      hintColor: AppColors.lowOpacityGrey,
      shadowColor: AppColors.veryLowOpacityGrey,
      focusColor: AppColors.black,
      disabledColor: AppColors.black54,
      dialogBackgroundColor: AppColors.black87,
      hoverColor: isThatMobile ? AppColors.black45 : AppColors.transparent,
      indicatorColor: AppColors.black38,
      dividerColor: AppColors.black12,
      cardColor: AppColors.lightBlack,
      scaffoldBackgroundColor:
          isThatMobile ? AppColors.white : AppColors.customGreyForWeb,
      iconTheme: const IconThemeData(color: AppColors.black38),
      chipTheme:
          const ChipThemeData(backgroundColor: AppColors.veryLowOpacityGrey),
      highlightColor: AppColors.lowOpacityGrey,
      canvasColor: AppColors.transparent,
      splashColor: AppColors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: AppColors.white,
        shadowColor: AppColors.lowOpacityGrey,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle:
            getNormalStyle(fontSize: FontSize.s16, color: AppColors.black),
      ),
      textTheme: TextTheme(
        bodyLarge: getNormalStyle(color: AppColors.black),
        bodyMedium: getNormalStyle(color: AppColors.imageGrey),
        bodySmall: getNormalStyle(color: AppColors.grey),
        displayLarge: getNormalStyle(color: AppColors.grey, fontSize: 15),
        displayMedium: getBoldStyle(color: AppColors.black, fontSize: 15),
        displaySmall: getMediumStyle(color: AppColors.black, fontSize: 15),
        headlineSmall: getNormalStyle(color: AppColors.shimmerLightGrey),
        titleLarge: getNormalStyle(color: Colors.white),
        titleSmall: getNormalStyle(color: AppColors.darkWhite),
        titleMedium: getNormalStyle(color: AppColors.lightGrey),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.black26),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: AppColors.black,
      primaryColorLight: AppColors.black54,
      primarySwatch: Colors.grey,
      hintColor: AppColors.darkGray,
      shadowColor: AppColors.darkGray,
      focusColor: AppColors.white,
      dialogBackgroundColor: AppColors.white,
      highlightColor: AppColors.grey,
      useMaterial3: true,
      hoverColor: isThatMobile ? AppColors.grey : AppColors.transparent,
      indicatorColor: AppColors.grey,
      dividerColor: AppColors.grey,
      iconTheme: const IconThemeData(color: AppColors.white),
      chipTheme: const ChipThemeData(backgroundColor: AppColors.lightDarkGray),
      cardColor: AppColors.darkGray,
      disabledColor: AppColors.white,
      scaffoldBackgroundColor: AppColors.black,
      canvasColor: AppColors.transparent,
      splashColor: AppColors.darkGray,
      appBarTheme: AppBarTheme(
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        color: AppColors.black,
        shadowColor: AppColors.lowOpacityGrey,
        titleTextStyle:
            getNormalStyle(fontSize: FontSize.s16, color: AppColors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: getNormalStyle(color: AppColors.white),
        bodyMedium: getNormalStyle(color: AppColors.darkGray),
        bodySmall: getNormalStyle(color: AppColors.lightGrey),
        displayLarge: getNormalStyle(color: AppColors.grey, fontSize: 15),
        displayMedium: getBoldStyle(color: AppColors.white, fontSize: 15),
        displaySmall: getMediumStyle(color: AppColors.white, fontSize: 15),
        headlineSmall: getNormalStyle(color: Colors.grey[500]!),
        titleLarge: getNormalStyle(color: AppColors.shimmerDarkGrey),
        titleSmall: getNormalStyle(color: AppColors.darkGray),
        titleMedium: getNormalStyle(color: AppColors.darkGray),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.grey),
    );
  }
}
