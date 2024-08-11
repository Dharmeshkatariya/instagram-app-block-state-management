//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:messenger/features/presentation/blocs/shared_cubit/theme_cubit/theme_cubit.dart';
//
// import 'app_theme.dart';
//
// class ThemeDetector {
//   const ThemeDetector();
//
//   static void init(BuildContext context) {
//     try {
//       _listen(context);
//       View
//           .of(context)
//           .platformDispatcher
//           .onPlatformBrightnessChanged = () {
//         _listen(context);
//       };
//     } catch (e) {
//       return;
//     }
//   }
//
//   static void _listen(context) {
//     final brightness = View
//         .of(context)
//         .platformDispatcher
//         .platformBrightness;
//     bool isDark = (brightness == Brightness.dark) ? true : false;
//     ThemeData themeData = isDark ? AppTheme.darkTheme() : AppTheme
//         .lightTheme();
//     // BlocProvider.of<ThemeCubit>(context).setThemeData(themeData, isDark);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';

class ThemeOfApp {
  static final _box = GetStorage();
  static const _key = 'isDarkMode';
  static ThemeMode get theme =>
      isThemeDark() ? ThemeMode.dark : ThemeMode.light;

  static bool isThemeDark() => _box.read(_key) ?? false;

  static Future _saveThemeToBox() async =>
      await _box.write(_key, !isThemeDark());

  static Future<void> switchTheme() async {
    ThemeMode theme = isThemeDark() ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(theme);
    await _saveThemeToBox();
  }
}
