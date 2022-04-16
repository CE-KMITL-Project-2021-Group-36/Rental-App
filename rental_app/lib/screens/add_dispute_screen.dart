import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';

class AddDisputeScreen extends StatefulWidget {
  const AddDisputeScreen({Key? key, required this.contract}) : super(key: key);

  @override
  State<AddDisputeScreen> createState() => _AddDisputeScreenState();
  final Contract contract;
}

class _AddDisputeScreenState extends State<AddDisputeScreen> {
  CollectionReference disputes =
      FirebaseFirestore.instance.collection('disputes');
  CollectionReference contracts =
      FirebaseFirestore.instance.collection("contracts");

  late String _title = '';
  late String _detail = '';

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
    if (pickedFile!.path == null) retrieveLostData();
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
          'dispute_images/${FirebaseAuth.instance.currentUser?.uid}/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imageUrl.add(value);
          i++;
        });
      });
    }
  }

  createDispute() async {
    final contractRef = contracts.doc(widget.contract.id);
    await uploadFile();
    await disputes.doc(widget.contract.id).set({
      'contractId': widget.contract.id,
      'title': _title,
      'detail': _detail,
      'imageUrls': FieldValue.arrayUnion(_imageUrl),
      'dateCreated': DateTime.now(),
    });
    await contractRef.update({
      'renterStatus': 'ข้อพิพาท',
      'ownerStatus': 'ข้อพิพาท',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เปิดข้อพิพาท")),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'หมายเลขสัญญาเช่า:' + widget.contract.id,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'หัวข้อ/สาเหตุ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 4),
              TextFormField(
                onChanged: (value) {
                  _title = value;
                },
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'ใส่หัวข้อ/สาเหตุ',
                  alignLabelWithHint: true,
                ),
                maxLength: 100,
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
                onChanged: (value) {
                  _detail = value;
                },
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'ใส่ข้อความรายละเอียด',
                  alignLabelWithHint: true,
                ),
                maxLength: 100,
              ),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
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
              TextButton(
                child: const Text('เปิดข้อพิพาท'),
                onPressed: () async {
                  await createDispute();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('เปิดข้อพิพาทสำเร็จ'),
                  ));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  primary: Colors.white,
                  backgroundColor: primaryColor,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
