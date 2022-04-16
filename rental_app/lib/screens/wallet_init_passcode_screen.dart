import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:rental_app/config/palette.dart';

class WalletInitPasscode extends StatefulWidget {
  const WalletInitPasscode({Key? key}) : super(key: key);

  @override
  State<WalletInitPasscode> createState() => _WalletInitPasscodeState();

  static const String routeName = '/wallet_init_passcode';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const WalletInitPasscode(),
    );
  }
}

class _WalletInitPasscodeState extends State<WalletInitPasscode> {
  bool onConfirmScreen = false;
  final pinController = TextEditingController();
  String passcode = '';
  static const String initScreenText = 'กำหนดรหัสผ่าน\nWallet',
      confirmScreenText = 'ยืนยันรหัสผ่าน\nWallet';
  String displayText = initScreenText;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: primaryColor,
          onPressed: () {
            if (onConfirmScreen) {
              setState(() {
                displayText = initScreenText;
                onConfirmScreen = false;
                passcode = '';
              });
            }
          },
        ),
        actions: onConfirmScreen
            ? null
            : [
                TextButton(
                  onPressed: () {
                    onConfirmScreen = true;
                    setState(() {
                      displayText = confirmScreenText;
                    });
                    passcode = pinController.text;
                    pinController.clear();
                  },
                  child: const Text('ยืนยัน  '),
                )
              ],
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
                controller: pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                validator: (s) {
                  if (onConfirmScreen) {
                    if (s == passcode) {
                      users.doc(userId).update({
                        "wallet.passcode": passcode,
                      });
                      Navigator.pushReplacementNamed(context, '/wallet');
                      return null;
                    } else {
                      Future.delayed(const Duration(milliseconds: 700), () {
                        pinController.clear();
                      });
                      return 'รหัสผ่านไม่ตรงกัน กรุณาลองอีกครั้ง';
                    }
                  }
                  return null;
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
