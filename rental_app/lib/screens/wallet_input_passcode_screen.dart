import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/screens/wallet_init_passcode_screen.dart';

class WalletInputPasscode extends StatefulWidget {
  const WalletInputPasscode({Key? key}) : super(key: key);

  @override
  State<WalletInputPasscode> createState() => _WalletInputPasscodeState();

  static const String routeName = '/wallet_input_passcode';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const WalletInputPasscode(),
    );
  }
}

class _WalletInputPasscodeState extends State<WalletInputPasscode> {
  final pinController = TextEditingController();
  String displayText = 'ป้อนรหัสผ่าน\nWallet';
  String? passcode;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future getPasscode() async {
    DocumentSnapshot userSnapshot = await users.doc(userId).get();
    passcode = await userSnapshot['wallet']['passcode'];
    debugPrint(passcode);
  }

  @override
  void initState() {
    getPasscode();
    super.initState();
  }

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
                      controller: pinController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      showCursor: true,
                      validator: (s) {
                        if (s == passcode) {
                          Navigator.pushReplacementNamed(context, '/wallet');
                          return null;
                        } else {
                          Future.delayed(const Duration(milliseconds: 700), () {
                            pinController.clear();
                          });
                          return 'รหัสผ่านไม่ถูกต้อง กรุณาลองอีกครั้ง';
                        }
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
