// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/widgets/widget.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('This is route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return CustomNavBar.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
      ),
    );
  }
}
