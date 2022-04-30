import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:path/path.dart' as path;
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
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

  final TextEditingController _name = TextEditingController();
  final TextEditingController _pricePerDay = TextEditingController();
  final TextEditingController _pricePerWeek = TextEditingController();
  final TextEditingController _pricePerMonth = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _deposit = TextEditingController();
  final TextEditingController _location = TextEditingController();

  List<String> _imageUrl = [];
  String? _category;

  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool checkedPricePerWeek = false;
  bool checkedPricePerMonth = false;

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  final List<File> _imageFile = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _name.text = widget.product.name;
    _category = widget.product.category;
    _pricePerDay.text = widget.product.pricePerDay.toString();
    _pricePerWeek.text = widget.product.pricePerWeek.toString();
    _pricePerMonth.text = widget.product.pricePerMonth.toString();
    _imageUrl = widget.product.imageUrl;
    _description.text = widget.product.description;
    _location.text = widget.product.location;
    _deposit.text = widget.product.deposit;

    checkedPricePerWeek = widget.product.pricePerWeek > 0;
    checkedPricePerMonth = widget.product.pricePerMonth > 0;
  }

  chooseImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('กล้องถ่ายรูป'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('เลือกจากคลัง'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.gallery);
              },
            )
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      _imageFile.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    for (var img in _imageFile) {
      ref = storage.ref().child(
          'product_images/${FirebaseAuth.instance.currentUser?.uid}/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imageUrl.add(value);
        });
      });
    }
  }

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      await uploadFile();
      products.doc(widget.product.id).update({'imageUrl': []});
      products
          .doc(widget.product.id)
          .update({
            'name': _name.text,
            'pricePerDay': double.tryParse(_pricePerDay.text) ?? 0,
            'pricePerWeek': double.tryParse(_pricePerWeek.text) ?? 0,
            'pricePerMonth': double.tryParse(_pricePerMonth.text) ?? 0,
            'imageUrl': FieldValue.arrayUnion(_imageUrl),
            'category': _category,
            'deposit': _deposit.text,
            'description': _description.text,
            'location': _location.text,
            'dateCreated': DateTime.now(),
          })
          .then((value) => debugPrint('Product Updated'))
          .catchError(
              (error) => debugPrint('Failed to update product: $error'));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('อัพเดตสินค้าแล้ว'),
        ),
      );
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
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
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
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("แก้ไขสินค้า"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                showAlertDialog(context);
              },
              child: const Text(
                'ลบสินค้า',
                style: TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
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
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _imageUrl.length + _imageFile.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        const maxValue = 10;
                        final isMax =
                            _imageUrl.length + _imageFile.length == maxValue;
                        if (index == 0) {
                          return InkWell(
                            splashColor: primaryColor,
                            onTap: isMax
                                ? null
                                : (() {
                                    !uploading ? chooseImage() : null;
                                  }),
                            child: Ink(
                              decoration: BoxDecoration(
                                color:
                                    isMax ? Colors.grey[200] : primaryColor[50],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 56,
                                    color: isMax ? Colors.grey : primaryColor,
                                  ),
                                  Text(
                                    '${_imageUrl.length + _imageFile.length}/$maxValue',
                                    style: TextStyle(
                                      color: isMax ? Colors.grey : primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return index <= _imageUrl.length
                              ? Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              _imageUrl[index - 1]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: errorColor,
                                        ),
                                        tooltip: 'ลบรูปนี้',
                                        onPressed: () {
                                          setState(() {
                                            _imageUrl.removeAt(index - 1);
                                            print(_imageUrl.length);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(_imageFile[
                                              index - _imageUrl.length - 1]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: errorColor,
                                        ),
                                        tooltip: 'ลบรูปนี้',
                                        onPressed: () {
                                          setState(() {
                                            _imageFile.removeAt(
                                                index - _imageUrl.length - 1);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                        }
                      },
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
                              'ยืนยันการแก้ไข',
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
