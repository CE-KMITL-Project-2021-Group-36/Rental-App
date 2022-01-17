import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account_Page extends StatelessWidget {
  const Account_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User: ' + user.email.toString(),
            ),
            TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
