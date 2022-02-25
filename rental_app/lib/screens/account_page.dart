import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/providers/authentication_provider.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(firebaseAuthProvider);
    final _auth = ref.watch(authenticationProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 200,
              child: Image.network(
                data.currentUser!.photoURL ??
                    'https://cdn-icons-png.flaticon.com/512/147/147144.png',
              ),
            ),
            SizedBox(
              height: 50,
              child: Text(data.currentUser!.email ?? 'เข้าสู่ระบบแล้ว'),
            ),
            SizedBox(
              height: 50,
              child: Text(data.currentUser!.displayName ?? 'ชื่อ นามสกุล'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                _auth.signOut();
              },
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(top: 48.0),
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   width: double.infinity,
            //   child: MaterialButton(
            //     onPressed: () => _auth.signOut(),
            //     child: const Text(
            //       'Log Out',
            //       style: TextStyle(fontWeight: FontWeight.w600),
            //     ),
            //     textColor: Colors.blue.shade700,
            //     textTheme: ButtonTextTheme.primary,
            //     minWidth: 100,
            //     padding: const EdgeInsets.all(18),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(25),
            //       side: BorderSide(color: Colors.blue.shade700),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
