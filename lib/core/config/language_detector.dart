import 'dart:io';
import 'package:flutter/material.dart';

class LanguageDetector {
  const LanguageDetector();
  static TextDirection init(BuildContext context) {
    /// fa_IR => TextDirection.rtl
    /// en_US => TextDirection.ltr
    TextDirection direction = (Platform.localeName.toString() == "fa_IR")
        ? TextDirection.rtl
        : TextDirection.ltr;
    // context.read<DirectionalityCubit>().setDirectionality(direction);
    return direction;
  }
}
