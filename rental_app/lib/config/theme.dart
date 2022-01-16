import 'package:flutter/material.dart';
import 'package:rental_app/config/colors.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: primaryColor,
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: "Roboto",
    //textTheme: textTheme(),
  );
}

// TextTheme textTheme() {
//   return const TextTheme(
//     headline1: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.bold,
//       fontSize: 36,
//     ),
//     headline2: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.bold,
//       fontSize: 24,
//     ),
//     headline3: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.bold,
//       fontSize: 18,
//     ),
//     headline4: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     ),
//     headline5: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     ),
//     headline6: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.normal,
//       fontSize: 14,
//     ),
//     bodyText1: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.normal,
//       height: 1.75,
//       fontSize: 12,
//     ),
//     bodyText2: TextStyle(
//       color: textColor,
//       fontWeight: FontWeight.normal,
//       fontSize: 10,
//     ),
//   );
// }