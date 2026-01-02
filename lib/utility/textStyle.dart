import 'package:flutter/material.dart';

TextStyle regularTextStyle({
  required Color textColor,
  double fontSize=12.0,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}

TextStyle mediumTextStyle({
  required Color textColor,
   double fontSize = 16.0,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}

TextStyle largeTextStyle({
  required Color textColor,
  double fontSize = 24.0,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.w900,
}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}

