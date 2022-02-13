import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: primaryColor,
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: "SFThonburi",
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: primaryColor,
      centerTitle: true,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            // color: outlineColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: outlineColor,
          ),
        ),
        disabledBorder: InputBorder.none),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textTheme: textTheme(),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    headline1: TextStyle(fontSize: 96),
    headline2: TextStyle(fontSize: 60),
    headline3: TextStyle(fontSize: 48),
    headline4: TextStyle(fontSize: 34),
    headline5: TextStyle(fontSize: 24),
    headline6: TextStyle(fontSize: 20),
    subtitle1: TextStyle(fontSize: 16),
    subtitle2: TextStyle(fontSize: 14),
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    caption: TextStyle(fontSize: 12),
    overline: TextStyle(fontSize: 10),
  );
}
