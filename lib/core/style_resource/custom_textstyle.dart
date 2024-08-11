import '../../export.dart';

class FontWeightManager {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.normal;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.bold;
}

class FontSize {
  static const double s0 = 0.0;
  static const double s13 = 13.0;
  static const double s14 = 14.0;
  static const double s15 = 15.0;
  static const double s16 = 16.0;
  static const double s17 = 17.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
}

TextStyle _getTextStyle(
    double fontSize, FontWeight fontWeight, Color color, FontStyle fontStyle) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle);
}

TextStyle _getTextStyleWithNoSize(
    FontWeight fontWeight, Color color, FontStyle fontStyle) {
  return TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle);
}

TextStyle _whichTextStyle(
    double fontSize, FontWeight fontWeight, Color color, FontStyle fontStyle) {
  return fontSize == 0
      ? _getTextStyleWithNoSize(fontWeight, color, fontStyle)
      : _getTextStyle(fontSize, fontWeight, color, fontStyle);
}

TextStyle getLightStyle(
    {double fontSize = FontSize.s0,
    required Color color,
    FontStyle fontStyle = FontStyle.normal}) {
  return _whichTextStyle(fontSize, FontWeightManager.light, color, fontStyle);
}

TextStyle getNormalStyle(
    {double fontSize = FontSize.s0,
    required Color color,
    FontStyle fontStyle = FontStyle.normal}) {
  return _whichTextStyle(fontSize, FontWeightManager.regular, color, fontStyle);
}

TextStyle getMediumStyle(
    {double fontSize = FontSize.s0,
    required Color color,
    FontStyle fontStyle = FontStyle.normal}) {
  return _whichTextStyle(fontSize, FontWeightManager.medium, color, fontStyle);
}

TextStyle getBoldStyle(
    {double fontSize = FontSize.s0,
    required Color color,
    FontStyle fontStyle = FontStyle.normal}) {
  return _whichTextStyle(fontSize, FontWeightManager.bold, color, fontStyle);
}
