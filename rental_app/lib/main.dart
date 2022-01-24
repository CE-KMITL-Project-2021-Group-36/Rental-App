import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rental_app/views/authentication_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(const MyApp());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rental App',
      theme: theme(),
      home: const AuthChecker(),
    );
  }
}
