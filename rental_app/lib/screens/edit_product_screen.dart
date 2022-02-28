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
import 'package:rental_app/models/models.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();

  static const String routeName = '/edit_product';

  static Route route({required Product product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => EditProductScreen(product: product),
    );
  }
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //final owner = FirebaseAuth.instance.currentUser?.uid;
  var name = '';
  var category = '';
  var pricePerDay = 0.0;
  var pricePerWeek = 0.0;
  var pricePerMonth = 0.0;
  var imageUrl = '';
  var description = '';
  var location = '';
  var isFeature = false;
  var dateCreated;
  var deposit = '';

  bool checkedPricePerDay = false;
  bool checkedPricePerWeek = false;
  bool checkedPricePerMonth = false;

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  File? image;

  initState() {
    name = widget.product.name;
    category = widget.product.category;
    pricePerDay = widget.product.pricePerDay;
    pricePerWeek = widget.product.pricePerWeek;
    pricePerMonth = widget.product.pricePerMonth;
    imageUrl = widget.product.imageUrl;
    description = widget.product.description;
    location = widget.product.location;
    deposit = widget.product.deposit;
    dateCreated = widget.product.dateCreated;
    isFeature = widget.product.isFeature;
    checkedPricePerDay = pricePerDay > 0;
    checkedPricePerWeek = pricePerWeek > 0;
    checkedPricePerMonth = pricePerMonth > 0;
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      await ref.putFile(image!);
      await ref.getDownloadURL().then((loc) => setState(() => imageUrl = loc));
      //(imageUrl);
    } catch (e) {
      print('error occured');
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("ยกเลิก"),
      style: TextButton.styleFrom(
          primary: errorColor,
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ใช่ ลบสินค้า"),
      style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: errorColor,
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () async {
        await products.doc(widget.product.id).delete();
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ลบสินค้านี้แล้ว'),
        ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ลบสินค้า?"),
      content: const Text("การลบนี้จะลบสินค้านี้โดยถาวร"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขสินค้า"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
      ),
      body: Form(
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
                        const Icon(Icons.add_photo_alternate,
                            size: 56, color: primaryColor),
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
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Icon(Icons.add_photo_alternate,
                            size: 56, color: primaryColor),
                      ],
                    ),
                  ),
            const SizedBox(height: 16),
            const Text('ชื่อสินค้าที่ให้เช่า'),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                hintText: 'ใส่ชื่อสินค้า',
              ),
              maxLength: 50,
              onChanged: (value) {
                name = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณาใส่ชื่อสินค้า';
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
            const Text('ค่ามัดจำ'),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: deposit,
              onChanged: (value) {
                deposit = value;
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
              initialValue: description,
              onChanged: (value) {
                description = value;
              },
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'ใส่รายละเอียดสินค้า',
                alignLabelWithHint: true,
              ),
              maxLength: 200,
            ),
            const SizedBox(height: 32),
            const Text('ราคาให้เช่า'),
            const SizedBox(height: 4),
            CheckboxListTile(
              title: const Text('ราคาต่อวัน', style: TextStyle(fontSize: 14)),
              value: checkedPricePerDay,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerDay = newValue!;
                  if (!checkedPricePerDay) {
                    pricePerDay = 0;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            checkedPricePerDay
                ? TextFormField(
                    initialValue:
                        pricePerDay > 0 ? pricePerDay.toString() : null,
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
                : const SizedBox(),
            CheckboxListTile(
              title:
                  const Text('ราคาต่อสัปดาห์', style: TextStyle(fontSize: 14)),
              value: checkedPricePerWeek,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerWeek = newValue!;
                  if (!checkedPricePerWeek) {
                    pricePerWeek = 0;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            checkedPricePerWeek
                ? TextFormField(
                    initialValue:
                        pricePerWeek > 0 ? pricePerWeek.toString() : null,
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
                : const SizedBox(),
            CheckboxListTile(
              title: const Text('ราคาต่อเดือน', style: TextStyle(fontSize: 14)),
              value: checkedPricePerMonth,
              onChanged: (newValue) {
                setState(() {
                  checkedPricePerMonth = newValue!;
                  if (!checkedPricePerMonth) {
                    pricePerMonth = 0;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              dense: true,
            ),
            checkedPricePerMonth
                ? TextFormField(
                    initialValue:
                        pricePerMonth > 0 ? pricePerMonth.toString() : null,
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
                : const SizedBox(),
            const SizedBox(height: 32),
            const Text('ที่อยู่ของสินค้าให้เช่า'),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: location,
              onChanged: (value) {
                location = value;
              },
              decoration: const InputDecoration(
                hintText: 'ใส่ที่อยู่ของสินค้า',
              ),
            ),
            const SizedBox(height: 64),
            TextButton(
              child: const Text('แก้ไขสินค้านี้'),
              onPressed: () async {
                bool priceNotFilled = (pricePerDay == 0) &&
                    (pricePerWeek == 0) &&
                    (pricePerMonth == 0);
                if (_formKey.currentState!.validate()
                    //&& !priceNotFilled
                    ) {
                  await uploadFile();
                  products.doc(widget.product.id).update({
                    'name': name,
                    'pricePerDay': pricePerDay,
                    'pricePerWeek': pricePerWeek,
                    'pricePerMonth': pricePerMonth,
                    'imageUrl': imageUrl,
                    'category': category,
                    'deposit': deposit,
                    'description': description,
                    'location': location,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('อัปเดตสินค้าแล้ว'),
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
      dropdownElevation: 2,
      dropdownMaxHeight: 260,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      value: categories[categories.indexOf(widget.product.category)],
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
          return 'กรุณาเลือกหมวดหมู่';
        }
      },
      onChanged: (value) {
        category =
            value.toString(); //Do something when changing the item if you want.
      },
      onSaved: (value) {},
    );
  }
}
