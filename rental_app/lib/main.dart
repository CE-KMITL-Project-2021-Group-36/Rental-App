import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rental_app/injection.dart';
import 'package:rental_app/presentation/core/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // need explicit binding before new Firebase call
  await Firebase.initializeApp(); // new Firebase call
  configureInjection(Environment.prod);
  runApp(const AppWidget());
}
