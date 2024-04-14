import 'package:flutter/material.dart';

class MyTheme {
  static const windowBorderRadius = BorderRadius.all(Radius.circular(40));
  static const padding = EdgeInsets.all(10);
  static const double windowSize = 400;
  static const double locationIconSize = 90;
  static const BoxShadow shadow = BoxShadow(
    color: Colors.black,
    blurRadius: 10,
    spreadRadius: 5,
    offset: Offset(0, 0),
  );
  static const double buttonIconSize = 30;
  static const double buttonSize = 55;
}
