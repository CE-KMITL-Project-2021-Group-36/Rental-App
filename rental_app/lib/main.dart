import 'package:flutter/material.dart';
import './navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Flutter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const Navigation_Bar(),
    );
  }
}
