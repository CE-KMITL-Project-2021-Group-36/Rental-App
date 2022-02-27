import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _messageToDisplay = '';

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          _messageToDisplay = 'อีเมลไม่ถูกต้อง';
          break;
        case 'user-disabled':
          _messageToDisplay = 'บัญชีถูกระงับการใช้งาน กรุณาติดต่อผู้ดูแลระบบ';
          break;
        case 'user-not-found':
          _messageToDisplay = 'ไม่พบบัญชีผู้ใช้งาน';
          break;
        case 'wrong-password':
          _messageToDisplay = 'รหัสผ่านไม่ถูกต้อง';
          break;
        default:
          _messageToDisplay = 'ไม่ทราบสาเหตุ';
          break;
      }
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('เกิดข้อผิดพลาด'),
          content: Text(_messageToDisplay),
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
    String email,
    String password,
    String idCardNumber,
    String firstName,
    String lastName,
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').add({
        'userId': _auth.currentUser!.uid,
        'email': email,
        'idCardNumber': idCardNumber,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'kycVerified': false,
        'kycStatus': 'ยังไม่ยืนยันตัวตน',
        'role': 'User',
        'hasShop': false,
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          _messageToDisplay = 'อีเมลนี้มีผู้ใช้งานแล้ว';
          break;
        case 'invalid-email':
          _messageToDisplay = 'อีเมลไม่ถูกต้อง';
          break;
        case 'operation-not-allowed':
          _messageToDisplay = 'ระบบขัดข้อง กรุณาติดต่อผู้ดูแลระบบ';
          break;
        case 'weak-password':
          _messageToDisplay = 'รหัสผ่านไม่ปลอดภัย';
          break;
        default:
          _messageToDisplay = 'ไม่ทราบสาเหตุ';
          break;
      }
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('เกิดข้อผิดพลาด'),
                  content: Text(_messageToDisplay),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("ตกลง"))
                  ]));
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
      debugPrint(e.code);
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
    await googleUser.signOut();
    await _auth.signOut();
  }
}
