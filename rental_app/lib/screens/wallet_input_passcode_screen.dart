import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/screens/wallet_init_passcode_screen.dart';

class WalletInputPasscode extends StatefulWidget {
  const WalletInputPasscode({Key? key, required this.fromRoute})
      : super(key: key);

  final String fromRoute;

  @override
  State<WalletInputPasscode> createState() => _WalletInputPasscodeState();

  static const String routeName = '/wallet_input_passcode';

  static Route route({required String fromRoute}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => WalletInputPasscode(fromRoute: fromRoute),
    );
  }
}

class _WalletInputPasscodeState extends State<WalletInputPasscode> {
  final pinController = TextEditingController();
  String displayText = 'ป้อนรหัสผ่าน\nWallet';
  String? passcode;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: primaryLightColor,
      ),
    );

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ข้อมูลผิดพลาด");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("ไม่พบข้อมูล");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            passcode = snapshot.data!['wallet']['passcode'];
            debugPrint(passcode);
            return passcode == null
                ? const WalletInitPasscode()
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: const BackButton(
                        color: primaryColor,
                      ),
                    ),
                    body: SafeArea(
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 80),
                              child: Text(
                                displayText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Pinput(
                              obscureText: true,
                              controller: pinController,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              showCursor: true,
                              validator: (s) {
                                if (s == passcode) {
                                  if (widget.fromRoute == 'wallet') {
                                    Navigator.pushReplacementNamed(
                                        context, '/wallet');
                                  }
                                  if (widget.fromRoute == 'payment') {
                                    Navigator.pop(context, true);
                                  }
                                  return null;
                                } else {
                                  Future.delayed(
                                      const Duration(milliseconds: 700), () {
                                    pinController.clear();
                                  });
                                  return 'รหัสผ่านไม่ถูกต้อง กรุณาลองอีกครั้ง';
                                }
                              },
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
