import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class EditPhoneNumberScreen extends StatefulWidget {
  const EditPhoneNumberScreen({Key? key, required this.phone})
      : super(key: key);

  final String phone;

  static const String routeName = '/edit_phone';

  static Route route({required String phone}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => EditPhoneNumberScreen(
        phone: phone,
      ),
    );
  }

  @override
  State<EditPhoneNumberScreen> createState() => _EditPhoneNumberScreenState();
}

class _EditPhoneNumberScreenState extends State<EditPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      Navigator.pop(context);
      users.doc(userId).update({'phoneNumber': widget.phone});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _phone.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(title: const Text('แก้ไขเบอร์โทรศัพท์')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: _continuousValidation,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return Form(
                        autovalidateMode: _continuousValidation.value
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _phone,
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
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'โปรดระบุเบอร์โทรศัพท์';
                                } else if (input.length < 10) {
                                  return 'เบอร์โทรศัพท์ไม่ครบ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _phone,
                                builder: (context, value, child) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          child: Text(
                                            'บันทึก',
                                            style: textTheme().button,
                                          ),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor:
                                                value.text.isNotEmpty
                                                    ? primaryColor
                                                    : primaryLightColor,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                          ),
                                          onPressed: value.text.isNotEmpty
                                              ? _onPressedFunction
                                              : null,
                                        ),
                                      ),
                                    ],
                                  );
                                })
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
