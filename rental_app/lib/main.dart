import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Test Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const BottomNavBar(),

    );
  }
}