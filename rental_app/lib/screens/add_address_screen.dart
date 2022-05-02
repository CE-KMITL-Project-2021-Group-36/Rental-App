import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key, required this.documentId})
      : super(key: key);

  final String documentId;

  static const String routeName = '/add_address';

  static Route route({required String documentId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => AddAddressScreen(
        documentId: documentId,
      ),
    );
  }

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      Navigator.pop(context);
      if (widget.documentId == '') {
        users.doc(userId).collection('address').add({
          'name': _name.text,
          'phone': _phone.text,
          'address': _address.text
        });
      } else {
        users.doc(userId).collection('address').doc(widget.documentId).update({
          'name': _name.text,
          'phone': _phone.text,
          'address': _address.text
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    debugPrint(widget.documentId);
    if (widget.documentId != '') {
      users
          .doc(userId)
          .collection('address')
          .doc(widget.documentId)
          .get()
          .then((value) {
        _name.text = value.data()!['name'];
        _phone.text = value.data()!['phone'];
        _address.text = value.data()!['address'];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          title: widget.documentId == ''
              ? const Text('เพิ่มที่อยู่ใหม่')
              : const Text('แก้ไขที่อยู่ใหม่'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                                controller: _name,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'ชื่อผู้รับ',
                                ),
                                autocorrect: false,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'โปรดระบุชื่อ';
                                  } else if (!RegExp(
                                          r"""^[ กขฃคฅฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุูเแโใไๅ็่้๊๋์]+$""")
                                      .hasMatch(input)) {
                                    return 'ต้องเป็นภาษาไทยเท่านั้น';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _address,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.location_on),
                                  labelText: 'ที่อยู่',
                                ),
                                maxLines: 5,
                                maxLength: 150,
                                autocorrect: false,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'โปรดระบุที่อยู่';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _address,
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
      ),
    );
  }
}
