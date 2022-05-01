import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class KYC extends StatefulWidget {
  const KYC({Key? key, required this.status}) : super(key: key);

  final String status;

  @override
  State<KYC> createState() => _KYCState();

  static const String routeName = '/kyc';

  static Route route({required String status}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => KYC(
        status: status,
      ),
    );
  }
}

enum PhotoType { front, selfie }

class _KYCState extends State<KYC> {
  bool picked = false;
  String? userId, firstName, lastName;
  XFile? _frontPhoto, _selfiePhoto;
  final ImagePicker _picker = ImagePicker();

  Future _selectPhoto(PhotoType photoType) async {
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
                      _pickPhoto(ImageSource.camera, photoType);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('เลือกจากคลัง'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      _pickPhoto(ImageSource.gallery, photoType);
                    },
                  )
                ],
              ),
            ));
  }

  Future _pickPhoto(ImageSource source, PhotoType photoType) async {
    XFile? photo = await _picker.pickImage(source: source);
    setState(() {
      switch (photoType) {
        case PhotoType.front:
          _frontPhoto = photo;
          break;
        case PhotoType.selfie:
          _selfiePhoto = photo;
          break;
      }
      if (_frontPhoto != null && _selfiePhoto != null) {
        picked = true;
      }
    });
  }

  Future _uploadPhotosAndCreateKYC() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final frontPhotoRef =
        FirebaseStorage.instance.ref().child('kyc/$userId/front');
    final frontUpload = await frontPhotoRef.putFile(File(_frontPhoto!.path));
    String frontURL = await frontUpload.ref.getDownloadURL();
    final selfiePhotoRef =
        FirebaseStorage.instance.ref().child('kyc/$userId/selfie');
    final selfieUpload = await selfiePhotoRef.putFile(File(_selfiePhoto!.path));
    String selfieURL = await selfieUpload.ref.getDownloadURL();

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(userId).update(
      {
        'kyc.status': 'รอตรวจสอบ',
        'kyc.frontPhoto': frontURL,
        'kyc.selfiePhoto': selfieURL,
        'kyc.created': FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  Widget build(BuildContext context) => (widget.status == 'ยังไม่ยืนยันตัวตน' ||
          widget.status == 'โปรดยืนยันตัวตนอีกครั้ง')
      ? Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ยืนยันตัวตน KYC',
                      style: textTheme().headline4,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รูปถ่ายหน้าบัตรประชาชน',
                            style: textTheme().subtitle2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  child: DottedBorder(
                                      dashPattern: const [8, 8],
                                      strokeWidth: 2,
                                      color: primaryColor,
                                      child: _frontPhoto == null
                                          ? const SizedBox(
                                              height: 200,
                                              width: double.infinity,
                                            )
                                          : Image.file(
                                              File(_frontPhoto!.path),
                                              width: double.infinity,
                                              height: 200,
                                            ))),
                              Positioned(
                                child: CircleAvatar(
                                    radius: 50,
                                    child: IconButton(
                                      onPressed: () =>
                                          _selectPhoto(PhotoType.front),
                                      icon: const Icon(Icons.photo_camera),
                                      iconSize: 50,
                                    )),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'รูปถ่ายถือบัตรประชาชนคู่กับใบหน้า',
                              style: textTheme().subtitle2,
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  child: DottedBorder(
                                      dashPattern: const [8, 8],
                                      strokeWidth: 2,
                                      color: primaryColor,
                                      child: _selfiePhoto == null
                                          ? const SizedBox(
                                              height: 200,
                                              width: double.infinity,
                                            )
                                          : Image.file(
                                              File(_selfiePhoto!.path),
                                              width: double.infinity,
                                              height: 200,
                                            ))),
                              Positioned(
                                child: CircleAvatar(
                                    radius: 50,
                                    child: IconButton(
                                      onPressed: () =>
                                          _selectPhoto(PhotoType.selfie),
                                      icon: const Icon(Icons.photo_camera),
                                      iconSize: 50,
                                    )),
                              )
                            ],
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        insetPadding: EdgeInsets.zero,
                                        title: const Text(
                                            'รูปถ่ายถือบัตรประชาชนคู่กับใบหน้า'),
                                        content: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Fkyc_example.jpg?alt=media&token=fd0f7c20-becd-4497-8b8d-3c09f4b3c537',
                                          width: 300,
                                        ),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('ปิด'),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'แสดงตัวอย่าง',
                                style: textTheme().bodyText1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: picked
                                ? () {
                                    _uploadPhotosAndCreateKYC();
                                    // show success pop-up dialog
                                    // then press 'รับทราบ' and navigate to home screen
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  }
                                : null,
                            child: Text(
                              'ดำเนินการต่อ',
                              style: textTheme().button,
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                                  picked ? primaryColor : primaryLightColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Text(
                        'ดำเนินการภายหลัง',
                        style: textTheme().bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      : Scaffold(
          appBar: AppBar(
            title: Text('ยืนยันตัวตน'),
          ),
          body: Center(
            child: Text('อยู่ระหว่างการตรวจสอบ'),
          ),
        );
}
