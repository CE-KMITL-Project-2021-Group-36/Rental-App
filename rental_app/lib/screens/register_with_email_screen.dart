import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/providers/authentication_provider.dart';
import 'package:rental_app/screens/verify_email_screen.dart';

class RegisterWithEmailPage extends StatefulWidget {
  const RegisterWithEmailPage({Key? key}) : super(key: key);

  @override
  _RegisterWithEmailPageState createState() => _RegisterWithEmailPageState();
}

class _RegisterWithEmailPageState extends State<RegisterWithEmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _continuousValidation = false;
  bool isChecked = false;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _idCardNumber = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Consumer(builder: (context, ref, _) {
            final _auth = ref.watch(authenticationProvider);

            Color getColor(Set<MaterialState> states) {
              return primaryColor;
            }

            Future<void> _onPressedFunction() async {
              if (!_formKey.currentState!.validate()) {
                setState(() {
                  _continuousValidation = true;
                });
              } else {
                await _auth
                    .signUpWithEmailAndPassword(
                        _email.text,
                        _password.text,
                        _idCardNumber.text,
                        _firstName.text,
                        _lastName.text,
                        _phoneNumber.text,
                        context)
                    .whenComplete(
                        () => _auth.authStateChange.listen((event) async {
                              if (event == null) {
                                return;
                              }
                            }));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VerifyEmailPage()));
              }
            }

            return Form(
              key: _formKey,
              autovalidateMode: _continuousValidation
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        BackButton(),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                .hasMatch(input))
                          return 'รูปแบบอีเมลไม่ถูกต้อง';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'รหัสผ่าน',
                        errorMaxLines: 2,
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดระบุรหัสผ่าน';
                        } else if (!RegExp(
                                r"""(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*#?&^_-]).{8,}""")
                            .hasMatch(input)) {
                          return 'ต้องมีความยาว 8 ตัวอักษรขึ้นไป และต้องประกอบด้วยตัวอักษรภาษาอังกฤษ (A-Z), (a-z), (0-9) และอักขระพิเศษ อย่างน้อยอย่างละ 1 ตัว';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPassword,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'ยืนยันรหัสผ่าน',
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดยืนยันรหัสผ่าน';
                        } else if (input != _password.text) {
                          return 'รหัสผ่านไม่ตรงกัน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _idCardNumber,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.credit_card),
                        labelText: 'เลขบัตรประจำตัวประชาชน 13 หลัก',
                        counterText: '',
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 13,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดระบุเลขบัตรประจำตัวประชาชน';
                        } else if (input.length < 13) {
                          return 'เลขบัตรประจำตัวประชาชนไม่ครบ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _firstName,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'ชื่อจริง',
                      ),
                      autocorrect: false,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดระบุชื่อ';
                        } else if (!RegExp(
                                r"""^[กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุูเแโใไๅ็่้๊๋์]+$""")
                            .hasMatch(input)) {
                          return 'ต้องเป็นภาษาไทยเท่านั้น';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastName,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'นามสกุล',
                      ),
                      autocorrect: false,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดระบุนามสกุล';
                        } else if (!RegExp(
                                r"""^[กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุูเแโใไๅ็่้๊๋์]+$""")
                            .hasMatch(input)) {
                          return 'ต้องเป็นภาษาไทยเท่านั้น';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneNumber,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'เบอร์โทรศัพท์',
                        counterText: '',
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดระบุเบอร์โทรศัพท์';
                        } else if (input.length < 10) {
                          return 'เบอร์โทรศัพท์ไม่ครบ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          shape: const CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          'ข้าพเจ้ายอมรับ',
                          style: textTheme().bodyText1,
                        ),
                        GestureDetector(
                          child: Text(
                            ' เงื่อนไขและข้อตกลง',
                            style: textTheme().bodyText1?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('เงื่อนไขและข้อตกลง'),
                                    content: const Text(
                                        'แอปพลิเคชันนี้มีการเก็บข้อมูลส่วนตัวของผู้ใช้เพื่อประโยชน์ในการยืนยันตัวตนและความปลอดภัยในการใช้งานแอปพลิเคชันของผู้ใช้งานทุกท่าน\nผู้พัฒนามีแนวทางในการจัดเก็บข้อมูลของท่านเพื่อป้องกันการรั่วไหลของข้อมูล\nแอปพลิเคชันและทีมผู้พัฒนาจะไม่รับผิดชอบต่อการฉ้อโกงที่อาจเกิดขึ้น\nโปรดตัดสินใจอย่างรอบคอบก่อนการทำธุรกรรม\nหากมีข้อสงสัยกรุณาติดต่อผู้พัฒนา'),
                                    actions: [
                                      Center(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('ปิด')),
                                      )
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: isChecked ? _onPressedFunction : null,
                      child: Text(
                        'สมัครสมาชิก',
                        style: textTheme().button,
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor:
                            isChecked ? primaryColor : primaryLightColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
