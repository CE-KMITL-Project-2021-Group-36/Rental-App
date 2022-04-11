import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';

String currencyFormat(double n) {
  final formatter = NumberFormat("#,###.##");
  //n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  return formatter.format(n);
}

ThemeData theme() {
  return ThemeData(
    primaryColor: primaryColor,
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: "SFThonburi",
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: primaryColor,
      //centerTitle: true,
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
    headline4: TextStyle(
        fontSize: 36, fontWeight: FontWeight.bold, color: primaryColor),
    headline5: TextStyle(fontSize: 24),
    headline6: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(fontSize: 18),
    subtitle2: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    caption: TextStyle(fontSize: 12),
    overline: TextStyle(fontSize: 10),
  );
}
// TextTheme textTheme() {
//   return const TextTheme(
//     headline1: TextStyle(
//         fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
//     headline2: TextStyle(
//         fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
//     headline3: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
//     headline4: TextStyle(
//         fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
//     headline5: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
//     headline6: TextStyle(
//         fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
//     subtitle1: TextStyle(
//         fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
//     subtitle2: TextStyle(
//         fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
//     bodyText1: TextStyle(
//         fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
//     bodyText2: TextStyle(
//         fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
//     button: TextStyle(
//         fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
//     caption: TextStyle(
//         fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
//     overline: TextStyle(
//         fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
//   ).apply(bodyColor: textColor);
//}
