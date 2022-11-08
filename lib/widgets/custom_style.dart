import 'package:flutter/material.dart';

class CustomStyle {
  List<BoxShadow> boxShadow = [
    const BoxShadow(
        color: Color.fromRGBO(84, 110, 247, 0.3),
        blurRadius: 10.0,
        spreadRadius: 2.0,
        offset: Offset(0, 2))
  ];

  List<BoxShadow> buttonBoxShadow = [
    const BoxShadow(
        color: Color.fromRGBO(84, 110, 247, 0.1),
        blurRadius: 5.0,
        spreadRadius: 2.0,
        offset: Offset(0, 0))
  ];

  List<BoxShadow> boxShadowLowBlur = [
    const BoxShadow(
        color: Color.fromRGBO(84, 110, 247, 0.3),
        blurRadius: 8.0,
        spreadRadius: 0.0,
        offset: Offset(0, 3))
  ];

  List<BoxShadow> bottomBarShadow = [
    const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        blurRadius: 20.0,
        spreadRadius: 20.0,
        offset: Offset(0, 25))
  ];

  List<BoxShadow> bottomBarShadow1 = [
    const BoxShadow(
        color: Color.fromRGBO(84, 110, 247, 0.1),
        blurRadius: 8.0,
        spreadRadius: 0.0,
        offset: Offset(0, 3))
  ];

  List<BoxShadow> mainThemeButtonShadow = [
    const BoxShadow(
        color: Color.fromRGBO(84, 110, 247, 0.3),
        blurRadius: 40.0,
        spreadRadius: 2.0,
        offset: Offset(0, 25))
  ];
}
