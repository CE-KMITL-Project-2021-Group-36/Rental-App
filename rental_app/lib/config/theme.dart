import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

const primaryColor = Palette.bluePurple;
const primaryLightColor = Color(0xffF0EEFF);
const secondaryColor = Color(0xff0ACF97);
const textColor = Color(0xff212121);
const surfaceColor = Color(0xffFFFFFF);
const backgroundColor = Color(0xffFBFBFF);

ThemeData theme() {
  return ThemeData(
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: "",
    textTheme: textTheme(),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    headline1: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 36,
    ),
    headline2: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    headline3: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    headline4: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    headline5: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
    bodyText1: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      height: 1.75,
      fontSize: 12,
    ),
    bodyText2: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 10,
    ),
  );
}