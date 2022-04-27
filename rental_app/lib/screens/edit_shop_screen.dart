import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class EditShopScreen extends StatefulWidget {
  const EditShopScreen({Key? key}) : super(key: key);

  static const String routeName = '/edit_shop';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EditShopScreen(),
    );
  }

  @override
  State<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopName = TextEditingController();
  final TextEditingController _shopDetail = TextEditingController();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();

  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
     _getData();
  }

  _getData() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      _shopName.text = data?['shop']['shopName'];
      _shopDetail.text = data?['shop']['shopDetail'];
      _name.text = data?['shop']['userName'];
      _phone.text = data?['shop']['phone'];
      _address.text = data?['shop']['address'];
    }
    setState(() {});
  }

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      Navigator.pop(context);
      users.doc(userId).update({
        'shop.hasShop': true,
        'shop.shopName': _shopName.text,
        'shop.shopDetail': _shopDetail.text,
        'shop.userName': _name.text,
        'shop.phone': _phone.text,
        'shop.address': _address.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(title: const Text('แก้ไขข้อมูลร้าน')),
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
                                controller: _shopName,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.storefront),
                                  labelText: 'ชื่อร้าน',
                                ),
                                autocorrect: false,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'โปรดระบุชื่อร้าน';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _shopDetail,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.create),
                                  labelText: 'รายละเอียดของร้าน',
                                ),
                                maxLines: 4,
                                maxLength: 200,
                                autocorrect: false,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'โปรดระบุที่อยู่';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: const [
                                  Text(
                                    'รายละเอียดที่อยู่',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
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
                                maxLines: 4,
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
                                              'ยืนยันการแก้ไข',
                                              style: textTheme().button,
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor:
                                                  value.text.isNotEmpty
                                                      ? primaryColor
                                                      : primaryLightColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                              ),
                                            ),
                                            //onPressed: () {},
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
