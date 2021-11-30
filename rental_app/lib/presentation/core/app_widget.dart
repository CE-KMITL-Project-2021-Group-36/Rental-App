import 'package:flutter/material.dart';
import 'package:rental_app/presentation/bottom_nav_bar.dart';
import 'package:rental_app/presentation/login/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const BottomNavBar(),
    );
  }
}
