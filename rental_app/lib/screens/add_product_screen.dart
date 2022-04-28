import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:path/path.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();

  static const String routeName = '/add_product';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AddProductScreen(),
    );
  }
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _pricePerDay = TextEditingController();
  final TextEditingController _pricePerWeek = TextEditingController();
  final TextEditingController _pricePerMonth = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _deposit = TextEditingController();
  final TextEditingController _location = TextEditingController();

  String? _imageUrl = 'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Fno_image.png?alt=media&token=8ad93981-0365-4bbb-8acf-55be80fe7013';
  String? _category;

  final String? _owner = FirebaseAuth.instance.currentUser?.uid;

  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool checkedPricePerWeek = false;
  bool checkedPricePerMonth = false;

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  File? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      await uploadFile();
      products
          .add({
            'owner': _owner,
            'name': _name.text,
            'pricePerDay': double.tryParse(_pricePerDay.text) ?? 0,
            'pricePerWeek': double.tryParse(_pricePerWeek.text) ?? 0,
            'pricePerMonth': double.tryParse(_pricePerMonth.text) ?? 0,
            'imageUrl': _imageUrl,
            'category': _category,
            'deposit': _deposit.text,
            'description': _description.text,
            'location': _location.text,
            'isFeature': false,
            'dateCreated': DateTime.now(),
          })
          .then((value) => debugPrint('Product Added'))
          .catchError((error) => debugPrint('Failed to add product: $error'));
      Navigator.pop(this.context);
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Text('เพิ่มสินค้าแล้ว'),
        ),
      );
    }
  }

  Future pickImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future uploadFile() async {
    if (image == null) return;
    final fileName = basename(image!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(image!);
      await ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
    } catch (e) {
      debugPrint('error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(title: const Text("เพิ่มสินค้า")),
        body: ValueListenableBuilder(
            valueListenable: _continuousValidation,
            builder: (BuildContext context, bool val, Widget? child) {
              return Form(
                autovalidateMode: _continuousValidation.value
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    image != null
                        ? InkWell(
                            onTap: () => pickImage(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor[50],
                                      borderRadius: BorderRadius.circular(4)),
                                  height: 300,
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 48,
                                  backgroundColor: primaryColor[50],
                                  child: const Icon(Icons.add_photo_alternate,
                                      size: 56, color: primaryColor),
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () => pickImage(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor[50],
                                      borderRadius: BorderRadius.circular(4)),
                                  height: 300,
                                ),
                                CircleAvatar(
                                  radius: 48,
                                  backgroundColor: primaryColor[50],
                                  child: const Icon(Icons.add_photo_alternate,
                                      size: 56, color: primaryColor),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 16),
                    const Text('ชื่อสินค้าที่ให้เช่า'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        hintText: 'ใส่ชื่อสินค้า',
                      ),
                      maxLength: 50,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดระบุชื่อสินค้า';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text('เลือกหมวดหมู่สินค้า'),
                    const SizedBox(height: 4),
                    buildCategory(),
                    const SizedBox(height: 32),
                    const SizedBox(height: 16),
                    const Text('เงื่อนไขค่ามัดจำ'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _deposit,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'โปรดระบุเงื่อนไขค่ามัดจำ';
                        }
                        return null;
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'ใส่รายละเอียดค่ามัดจำ',
                        alignLabelWithHint: true,
                      ),
                      maxLength: 200,
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(height: 16),
                    const Text('รายละเอียดสินค้า'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดระบุรายละเอียดสินค้า';
                        }
                        return null;
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'ใส่รายละเอียดสินค้า',
                        alignLabelWithHint: true,
                      ),
                      maxLength: 200,
                    ),
                    const SizedBox(height: 32),
                    const Text('ราคาต่อวัน', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pricePerDay,
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'โปรดระบุราคาต่อวัน';
                        }
                        if (value == '0' || value == '0.0' || value == '0.00') {
                          return 'โปรดระบุราคามากกว่า 0';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffix: Text('บาท'),
                        hintText: 'ใส่ราคาเช่าต่อวัน',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      maxLength: 10,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'ราคาต่อสัปดาห์ (7วัน)',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: checkedPricePerWeek,
                      onChanged: (newValue) {
                        setState(() {
                          checkedPricePerWeek = newValue!;
                          if (!checkedPricePerWeek) {
                            _pricePerWeek.clear();
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                    ),
                    checkedPricePerWeek
                        ? TextFormField(
                            controller: _pricePerWeek,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'โปรดระบุราคาต่อสัปดาห์';
                              }
                              if (value == '0' ||
                                  value == '0.0' ||
                                  value == '0.00') {
                                return 'โปรดระบุราคามากกว่า 0';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffix: Text('บาท'),
                              hintText: 'ใส่ราคาเช่าต่อสัปดาห์',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                          )
                        : const SizedBox(),
                    CheckboxListTile(
                      title: const Text(
                        'ราคาต่อเดือน (30วัน)',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: checkedPricePerMonth,
                      onChanged: (newValue) {
                        setState(() {
                          checkedPricePerMonth = newValue!;
                          if (!checkedPricePerMonth) {
                            _pricePerMonth.clear();
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                    ),
                    checkedPricePerMonth
                        ? TextFormField(
                            controller: _pricePerMonth,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'โปรดระบุราคาต่อเดือน';
                              }
                              if (value == '0' ||
                                  value == '0.0' ||
                                  value == '0.00') {
                                return 'โปรดระบุราคามากกว่า 0';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffix: Text('บาท'),
                              hintText: 'ใส่ราคาเช่าต่อเดือน',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                          )
                        : const SizedBox(),
                    const SizedBox(height: 32),
                    const Text('ที่อยู่ของสินค้าให้เช่า'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดระบุที่อยู่ของสินค้า';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'ใส่ที่อยู่ของสินค้า',
                      ),
                    ),
                    const SizedBox(height: 64),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text(
                              'เพิ่มสินค้า',
                              style: textTheme().button,
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            onPressed: _onPressedFunction,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildCategory() {
    final List<String> categories = [
      'เสื้อผ้าผู้ชาย',
      'เสื้อผ้าผู้หญิง',
      "อุปกรณ์ถ่ายภาพ",
      "ตั้งแคมป์",
      "หนังสือ",
      "อุปรณ์กีฬา",
      "อุปกรณ์อิเล็กทรอนิกส์",
      "อื่นๆ",
    ];

    return DropdownButtonFormField2(
      scrollbarThickness: 8,
      scrollbarRadius: const Radius.circular(20),
      dropdownElevation: 2,
      dropdownMaxHeight: 260,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      isExpanded: true,
      hint: const Text(
        'เลือกหมวดหมู่สินค้า',
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      items: categories
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == '' || value == null) {
          return 'กรุณาเลือกหมวดหมู่';
        }
        return null;
      },
      value: _category,
      onChanged: (value) {
        _category = value.toString();
      },
    );
  }
}
