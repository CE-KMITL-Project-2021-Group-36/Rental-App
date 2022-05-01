import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/providers/authentication_provider.dart';
import 'package:rental_app/widgets/custom_navbar.dart';

class RegisterWithGoogleScreen extends StatefulWidget {
  const RegisterWithGoogleScreen({Key? key}) : super(key: key);

  @override
  _RegisterWithGoogleScreenState createState() =>
      _RegisterWithGoogleScreenState();
}

class _RegisterWithGoogleScreenState extends State<RegisterWithGoogleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _continuousValidation = false;
  bool isChecked = false;

  final String _email = FirebaseAuth.instance.currentUser!.email.toString();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final _idCardNumber = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
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
                          .signUpWithGoogle(
                              _email,
                              _idCardNumber.text,
                              _firstName.text,
                              _lastName.text,
                              _phoneNumber.text,
                              userId,
                              context)
                          .whenComplete(
                              () => Navigator.pushNamed(context, '/'));
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
                            controller: _idCardNumber,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.credit_card),
                              labelText: 'เลขบัตรประจำตัวประชาชน 13 หลัก',
                              counterText: '',
                            ),
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                                          title:
                                              const Text('เงื่อนไขและข้อตกลง'),
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

        if (snapshot.connectionState == ConnectionState.done) {
          return const CustomNavBar();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
