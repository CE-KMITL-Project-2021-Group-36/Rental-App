import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:path/path.dart' as path;
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();

  final String name;

  static const String routeName = '/report';

  static Route route({required String name}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ReportScreen(name: name),
    );
  }
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');

  final TextEditingController _title = TextEditingController();
  final TextEditingController _detail = TextEditingController();
  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  final List<File> _image = [];
  final List _imageUrl = [];
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
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      debugPrint(response.file.toString());
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = storage.ref().child(
          'report_images/${FirebaseAuth.instance.currentUser?.uid}/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imageUrl.add(value);
          i++;
        });
      });
    }
  }

  createReport() async {
    await uploadFile();
    await reports.add({
      'active': true,
      'reporterId': FirebaseAuth.instance.currentUser!.uid,
      'reporterName': widget.name,
      'title': _title.text,
      'detail': _detail.text,
      'imageUrls': FieldValue.arrayUnion(_imageUrl),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(title: const Text('รายงานปัญหา')),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValueListenableBuilder(
                    valueListenable: _continuousValidation,
                    builder: (BuildContext context, bool val, Widget? child) {
                      return Form(
                        key: _formKey,
                        autovalidateMode: _continuousValidation.value
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'หัวข้อ/สาเหตุ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _title,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'ระบุหัวข้อ/สาเหตุ',
                                alignLabelWithHint: true,
                              ),
                              maxLength: 100,
                              validator: (input) {
                                if (input!.isEmpty) return 'โปรดระบุ';
                                return null;
                              },
                            ),
                            const Text(
                              'รายละเอียด',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _detail,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'ระบุรายละเอียด',
                                alignLabelWithHint: true,
                              ),
                              maxLength: 100,
                            ),
                          ],
                        ),
                      );
                    }),
                const SizedBox(height: 16),
                const Text(
                  'ภาพหลักฐานเพิ่มเติม',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _image.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? InkWell(
                            splashColor: primaryColor,
                            onTap: (() => !uploading ? chooseImage() : null),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: primaryColor[50],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: const Icon(Icons.add_rounded,
                                  color: primaryColor, size: 60),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: errorColor,
                                ),
                                tooltip: 'ลบรูปนี้',
                                onPressed: () {
                                  setState(() {
                                    _image.removeAt(index - 1);
                                  });
                                },
                              ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _detail,
                  builder: (context, value, child) => TextButton(
                    child: Text(
                      'ส่งรายงานปัญหา',
                      style: textTheme().button,
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        _continuousValidation.value = true;
                      } else {
                        await createReport();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('ส่งรายงานปัญหาสำเร็จ'),
                        ));
                      }
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: value.text.isNotEmpty
                          ? primaryColor
                          : primaryLightColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
