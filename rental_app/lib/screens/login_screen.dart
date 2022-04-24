import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/providers/authentication_provider.dart';
import 'package:rental_app/screens/register_with_email_screen.dart';
import 'package:rental_app/screens/reset_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _continuousValidation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          final _auth = ref.watch(authenticationProvider);

          Future<void> _onPressedFunction() async {
            if (!_formKey.currentState!.validate()) {
              setState(() {
                _continuousValidation = true;
              });
            } else {
              await _auth
                  .signInWithEmailAndPassword(
                      _email.text, _password.text, context)
                  .whenComplete(
                      () => _auth.authStateChange.listen((event) async {
                            if (event == null) {
                              return;
                            }
                          }));
            }
          }

          Future<void> _loginWithGoogle() async {
            await _auth
                .signInWithGoogle(context)
                .whenComplete(() => _auth.authStateChange.listen((event) async {
                      if (event == null) {
                        return;
                      }
                    }));
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
                      'ลงชื่อเข้าใช้',
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
                    keyboardType: TextInputType.emailAddress,
                    validator: (input) {
                      if (input!.isEmpty ||
                          !RegExp(r"""^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""")
                              .hasMatch(input)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'รหัสผ่าน',
                    ),
                    autocorrect: false,
                    obscureText: true,
                    validator: (input) {
                      if (input!.isEmpty) return 'โปรดใส่รหัสผ่าน';
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen())),
                        child: Text(
                          'ลืมรหัสผ่าน?',
                          style: textTheme().bodyText1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _onPressedFunction,
                    child: const Text(
                      'เข้าสู่ระบบ',
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
                  const SizedBox(height: 30),
                  OutlinedButton.icon(
                    onPressed: _loginWithGoogle,
                    icon: const Icon(FontAwesomeIcons.google),
                    label: const Text(
                      'ดำเนินการต่อด้วย Google',
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
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'หรือ',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                const RegisterWithEmailPage())),
                    child: const Text(
                      'สมัครสมาชิกด้วยอีเมล',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
