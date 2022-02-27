import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/providers/authentication_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _email = TextEditingController();
  bool _continuousValidation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Consumer(builder: (context, ref, _) {
      final _firebase = ref.watch(firebaseAuthProvider);

      Future<void> _resetPassword() async {
        if (!_formKey.currentState!.validate()) {
          setState(() {
            _continuousValidation = true;
          });
        }
        await _firebase.sendPasswordResetEmail(email: _email.text.trim());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ส่งอีเมลสำเร็จ'),
            content: const Text(
                'กรุณาลองกดลิงก์จากอีเมลที่ได้รับเพื่อทำการเปลี่ยนรหัสผ่าน จากนั้นทำการเข้าสู่ระบบอีกครั้ง'),
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

      return Form(
        key: _formKey,
        autovalidateMode: _continuousValidation
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: const Text(
                  'กรอกอีเมล\nเพื่อเปลี่ยนรหัสผ่าน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'อีเมล',
                ),
                autocorrect: false,
                validator: (input) {
                  if (input!.isEmpty ||
                      !RegExp(r"""^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""")
                          .hasMatch(input)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                },
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: _resetPassword,
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                child: const Text(
                  'ย้อนกลับ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    })));
  }
}
