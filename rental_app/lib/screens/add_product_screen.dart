import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:path/path.dart' as path;

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

  final List<String> _imageUrl = [];
  String? _category;
  final String? _owner = FirebaseAuth.instance.currentUser?.uid;
  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool checkedPricePerWeek = false;
  bool checkedPricePerMonth = false;
  bool checkedPickUpAtShop = false;
  bool checkedDelivery = false;

  String _deliveryType = '';

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  final List<File> _imageFile = [];
  final picker = ImagePicker();

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
              title: const Text('????????????????????????????????????'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('????????????????????????????????????'),
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
    int i = 1;
    for (var img in _imageFile) {
      setState(() {
        val = i / _imageFile.length;
      });
      ref = storage.ref().child(
          'product_images/${FirebaseAuth.instance.currentUser?.uid}/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imageUrl.add(value);
          i++;
        });
      });
    }
  }

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      if (checkedPickUpAtShop && checkedDelivery) {
        _deliveryType = '????????????????????????????????????????????????/????????????????????????????????????';
      } else if (checkedPickUpAtShop){
        _deliveryType = '????????????????????????????????????????????????';
      } else if (checkedDelivery){
        _deliveryType = '????????????????????????????????????';
      } else {
        _deliveryType = '?????????????????????';
      }
      await uploadFile();
      products
          .add({
            'owner': _owner,
            'name': _name.text,
            'pricePerDay': double.tryParse(_pricePerDay.text) ?? 0,
            'pricePerWeek': double.tryParse(_pricePerWeek.text) ?? 0,
            'pricePerMonth': double.tryParse(_pricePerMonth.text) ?? 0,
            'imageUrl': FieldValue.arrayUnion(_imageUrl),
            'category': _category,
            'deposit': _deposit.text,
            'description': _description.text,
            'location': _location.text,
            'isFeature': false,
            'deliveryType': _deliveryType,
            'dateCreated': DateTime.now(),
          })
          .then((value) => debugPrint('Product Added'))
          .catchError((error) => debugPrint('Failed to add product: $error'));
      Navigator.pop(this.context);
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Text('?????????????????????????????????????????????'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(title: const Text("?????????????????????????????????")),
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
                      itemCount: _imageFile.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        const maxValue = 10;
                        final isMax = _imageFile.length == maxValue;
                        return index == 0
                            ? InkWell(
                                splashColor: primaryColor,
                                onTap: isMax
                                    ? null
                                    : (() {
                                        !uploading ? chooseImage() : null;
                                      }),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: isMax
                                        ? Colors.grey[200]
                                        : primaryColor[50],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 56,
                                        color:
                                            isMax ? Colors.grey : primaryColor,
                                      ),
                                      Text(
                                        '${_imageFile.length}/$maxValue',
                                        style: TextStyle(
                                          color: isMax
                                              ? Colors.grey
                                              : primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(_imageFile[index - 1]),
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
                                      tooltip: '????????????????????????',
                                      onPressed: () {
                                        setState(() {
                                          _imageFile.removeAt(index - 1);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 32),
                    const Text('????????????????????????????????????????????????????????????'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        hintText: '???????????????????????????????????????',
                      ),
                      maxLength: 50,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '??????????????????????????????????????????????????????';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text('?????????????????????????????????????????????????????????'),
                    const SizedBox(height: 4),
                    buildCategory(),
                    const SizedBox(height: 32),
                    const SizedBox(height: 16),
                    const Text('????????????????????????????????????????????????'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _deposit,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return '????????????????????????????????????????????????????????????????????????';
                        }
                        return null;
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: '???????????????????????????????????????????????????????????????',
                        alignLabelWithHint: true,
                      ),
                      maxLength: 200,
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(height: 16),
                    const Text('????????????????????????????????????????????????'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '????????????????????????????????????????????????????????????????????????';
                        }
                        return null;
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: '?????????????????????????????????????????????????????????',
                        alignLabelWithHint: true,
                      ),
                      maxLength: 200,
                    ),
                    const SizedBox(height: 32),
                    const Text('??????????????????????????????', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pricePerDay,
                      validator: (value) {
                        if (value == null || value == '') {
                          return '??????????????????????????????????????????????????????';
                        }
                        if (value == '0' || value == '0.0' || value == '0.00') {
                          return '????????????????????????????????????????????????????????? 0';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffix: Text('?????????'),
                        hintText: '???????????????????????????????????????????????????',
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
                        '?????????????????????????????????????????? (7?????????)',
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
                                return '??????????????????????????????????????????????????????????????????';
                              }
                              if (value == '0' ||
                                  value == '0.0' ||
                                  value == '0.00') {
                                return '????????????????????????????????????????????????????????? 0';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffix: Text('?????????'),
                              hintText: '???????????????????????????????????????????????????????????????',
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
                        '???????????????????????????????????? (30?????????)',
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
                                return '????????????????????????????????????????????????????????????';
                              }
                              if (value == '0' ||
                                  value == '0.0' ||
                                  value == '0.00') {
                                return '????????????????????????????????????????????????????????? 0';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              suffix: Text('?????????'),
                              hintText: '?????????????????????????????????????????????????????????',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                          )
                        : const SizedBox(),
                    const SizedBox(height: 32),
                    const Text('????????????????????????????????????????????????'),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text(
                        '????????????????????????????????????????????????',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: checkedPickUpAtShop,
                      onChanged: (newValue) {
                        setState(() {
                          checkedPickUpAtShop = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        '????????????????????????????????????',
                        style: TextStyle(fontSize: 14),
                      ),
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
                    const SizedBox(height: 32),
                    const Text('?????????????????????????????????????????????????????????????????????'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '????????????????????????????????????????????????????????????????????????';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '?????????????????????????????????????????????????????????',
                      ),
                    ),
                    const SizedBox(height: 64),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text(
                              '?????????????????????????????????',
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
      '??????????????????????????????????????????',
      '?????????????????????????????????????????????',
      "??????????????????????????????????????????",
      "???????????????????????????",
      "?????????????????????",
      "??????????????????????????????",
      "???????????????????????????????????????????????????????????????",
      "???????????????",
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
        '?????????????????????????????????????????????????????????',
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
          return '??????????????????????????????????????????????????????';
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
