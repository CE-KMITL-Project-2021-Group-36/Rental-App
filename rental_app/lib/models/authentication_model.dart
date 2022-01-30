import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('เกิดข้อผิดพลาด'),
          content: const Text('กรุณาลองอีกครั้ง'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("ตกลง"))
          ],
        ),
      );
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('เกิดข้อผิดพลาด'),
                  content: const Text('กรุณาลองอีกครั้ง'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("ตกลง"))
                  ]));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('เกิดข้อผิดพลาด'),
          content: const Text('กรุณาลองอีกครั้ง'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("ตกลง"))
          ],
        ),
      );
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleUser = GoogleSignIn();
    await _auth.signOut();
    await googleUser.signOut();
  }
}
