import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/widgets/custom_navbar.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  static const String routeName = '/verify';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const VerifyEmailPage(),
    );
  }

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // bool _isEmailVerified = false;
  late bool _isEmailVerified;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!_isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      // FirebaseAuth.instance.currentUser!;
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => _isEmailVerified
      ? const CustomNavBar()
      : Scaffold(
          body: SafeArea(
              child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: const Text(
                  'กรุณายืนยันอีเมล',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'ระบบได้ส่งลิงค์ไปยังอีเมลของท่านแล้ว\nกรุณากดลิงค์เพื่อทำการยืนยันอีเมล',
                style: textTheme().bodyText1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     'ส่งอีเมลอีกครั้ง',
              //     style: textTheme().button,
              //   ),
              //   style: TextButton.styleFrom(
              //     primary: Colors.white,
              //     backgroundColor: Colors.deepPurple,
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //   ),
              // ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  timer?.cancel();
                  FirebaseAuth.instance.signOut();
                },
                child: Text(
                  'ยกเลิก',
                  style: textTheme().button,
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        )));
}
