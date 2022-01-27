import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rental_app/config/app_router.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/widgets/widget.dart';

import 'package:rental_app/displayproducts.dart';
import 'package:rental_app/screens/screens.dart';
import 'bottom_nav_bar.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rental App',
      theme: theme(),
      //home: const DisplayProducts(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: CustomNavBar.routeName,
    );
  }
}