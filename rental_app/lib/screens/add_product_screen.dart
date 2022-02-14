import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/config/palette.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

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

final _formKey = GlobalKey<FormState>();
var name = '';
var category = '';
var pricePerDay = 0.0;
var pricePerWeek = 0.0;
var pricePerMonth = 0.0;
var imageUrl = '';

bool checkedPricePerDay = false;
bool checkedPricePerWeek = false;
bool checkedPricePerMonth = false;
bool checkedPickUp = false;
bool checkedDelivery = false;
bool checkedShipping = false;

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final owner = user?.uid;

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class _AddProductScreenState extends State<AddProductScreen> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future uploadFile() async {
    if (image == null) return;
    final fileName = basename(image!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      //.child('file/');
      await ref.putFile(image!);
      await ref.getDownloadURL().then((loc) => setState(() => imageUrl = loc));
      // final String _imageUrl = await ref.getDownloadURL().toString();
      // setState(() => imageUrl = _imageUrl);
      print(imageUrl);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มสินค้า")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            image != null
                ? Image.file(
                    image!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
            TextButton.icon(
              onPressed: () => pickImage(),
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('เพิ่มรูปภาพ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            const Text('ชื่อสินค้าที่ให้เช่า'),
            const SizedBox(height: 4),
            buildTitle(),
            const SizedBox(height: 16),
            const Text('รายละเอียดสินค้า'),
            const SizedBox(height: 4),
            buildDetail(),
            const SizedBox(height: 32),
            const SizedBox(height: 4),
            const Text('เลือกหมวดหมู่สินค้า'),
            const SizedBox(height: 4),
            buildCategory(),
            const SizedBox(height: 32),
            const Text('ราคาให้เช่า'),
            const SizedBox(height: 4),
            CheckboxListTile(
              title: const Text('ราคาต่อวัน', style: TextStyle(fontSize: 14)),
              value: checkedPricePerDay,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerDay = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            buildPrice(checkedPricePerDay),
            CheckboxListTile(
              title:
                  const Text('ราคาต่อสัปดาห์', style: TextStyle(fontSize: 14)),
              value: checkedPricePerWeek,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerWeek = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            buildPrice(checkedPricePerWeek),
            CheckboxListTile(
              title: const Text('ราคาต่อเดือน', style: TextStyle(fontSize: 14)),
              value: checkedPricePerMonth,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerMonth = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            buildPrice(checkedPricePerMonth),
            const SizedBox(height: 32),
            const Text('ที่อยู่ของสินค้าให้เช่า'),
            const SizedBox(height: 4),
            buildAddress(),
            const SizedBox(height: 32),
            const Text('การส่งสินค้า'),
            const SizedBox(height: 4),
            CheckboxListTile(
              title: const Text('นัดรับสินค้า', style: TextStyle(fontSize: 14)),
              value: checkedPickUp,
              onChanged: (newValue) {
                setState(() {
                  checkedPickUp = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            CheckboxListTile(
              title: const Text('ส่งสินค้าทางไปรษณีย์',
                  style: TextStyle(fontSize: 14)),
              value: checkedDelivery,
              onChanged: (newValue) {
                setState(() {
                  checkedDelivery = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            CheckboxListTile(
              title: const Text('ส่งสินค้าแบบด่วนในพื้นที่',
                  style: TextStyle(fontSize: 14)),
              value: checkedShipping,
              onChanged: (newValue) {
                setState(() {
                  checkedShipping = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            const SizedBox(height: 32),
            TextButton(
              child: const Text('เพิ่มสินค้านี้'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await uploadFile();
                  products
                      .add({
                        'owner': owner,
                        'name': name,
                        'pricePerDay': pricePerDay,
                        'pricePerWeek': pricePerWeek,
                        'pricePerMonth': pricePerMonth,
                        'imageUrl': imageUrl,
                        'category': category,
                      })
                      .then((value) => print('Product Added'))
                      .catchError(
                          (error) => print('Failed to add product: $error'));
                  Navigator.pop(context, '/user_store');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('เพิ่มสินค้าแล้ว'),
                  ));
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                primary: Colors.white,
                backgroundColor: primaryColor,
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildTitle() => TextFormField(
      decoration: const InputDecoration(
        hintText: 'ใส่ชื่อสินค้า',
      ),
      maxLength: 50,
      onChanged: (value) {
        name = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Plese enter some text';
        }
        return null;
      },
    );

Widget buildAddress() => TextFormField(
      decoration: const InputDecoration(
        hintText: 'ใส่ที่อยู่ของสินค้า',
      ),
    );

Widget buildDetail() => TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        //labelText: 'รายละเอียดสินค้า',
        hintText: 'ใส่รายละเอียดสินค้า',
        alignLabelWithHint: true,
      ),
      maxLength: 200,
    );

Widget buildPrice(checkedValue) {
  return checkedValue
      ? TextFormField(
          decoration: const InputDecoration(
            suffix: Text('บาท'),
            hintText: 'ใส่ราคาเช่าต่อวัน',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            pricePerDay = double.parse(value);
          },
          maxLength: 10,
          keyboardType: TextInputType.number,
        )
      : const SizedBox();
}

Widget buildPricePerWeek(checkedValue) {
  return checkedValue
      ? TextFormField(
          decoration: const InputDecoration(
            suffix: Text('บาท'),
            hintText: 'ใส่ราคาเช่าต่อสัปดาห์',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            pricePerWeek = double.parse(value);
          },
          maxLength: 10,
          keyboardType: TextInputType.number,
        )
      : const SizedBox();
}

Widget buildPricePerMonth(checkedValue) {
  return checkedValue
      ? TextFormField(
          decoration: const InputDecoration(
            suffix: Text('บาท'),
            hintText: 'ใส่ราคาเช่าต่อเดือน',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            pricePerMonth = double.parse(value);
          },
          maxLength: 10,
          keyboardType: TextInputType.number,
        )
      : const SizedBox();
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

  String? selectedValue;

  return DropdownButtonFormField2(
    dropdownElevation: 2,
    dropdownMaxHeight: 260,
    decoration: const InputDecoration(
      //Add isDense true and zero Padding.
      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
      isDense: true,
      contentPadding: EdgeInsets.zero,
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(15),
      // ),
      //Add more decoration as you want here
      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
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
      if (value == null) {
        return 'Please select gender.';
      }
    },
    onChanged: (value) {
      category =
          value.toString(); //Do something when changing the item if you want.
    },
    onSaved: (value) {
      selectedValue = value.toString();
    },
  );
}
