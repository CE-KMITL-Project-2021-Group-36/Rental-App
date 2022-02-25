import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class KYC extends StatefulWidget {
  const KYC({Key? key}) : super(key: key);

  @override
  State<KYC> createState() => _KYCState();
}

enum PhotoType { front, back, selfie }

class _KYCState extends State<KYC> {
  bool picked = false;
  String? userId, firstName, lastName;
  XFile? _frontPhoto, _backPhoto, _selfiePhoto;
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
        case PhotoType.back:
          _backPhoto = photo;
          break;
        case PhotoType.selfie:
          _selfiePhoto = photo;
          break;
      }
      if (_frontPhoto != null && _backPhoto != null && _selfiePhoto != null) {
        picked = true;
      }
    });
  }

  Future _getUserData() async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    firstName = snapshot.get('firstName');
    lastName = snapshot.get('lastName');
  }

  Future _uploadPhotosAndCreateKYC() async {
    _getUserData();
    final frontPhotoRef =
        FirebaseStorage.instance.ref().child('kyc/$userId/front');
    final frontUpload = await frontPhotoRef.putFile(File(_frontPhoto!.path));
    String frontURL = await frontUpload.ref.getDownloadURL();
    final backPhotoRef =
        FirebaseStorage.instance.ref().child('kyc/$userId/back');
    final backUpload = await backPhotoRef.putFile(File(_backPhoto!.path));
    String backURL = await backUpload.ref.getDownloadURL();
    final selfiePhotoRef =
        FirebaseStorage.instance.ref().child('kyc/$userId/selfie');
    final selfieUpload = await selfiePhotoRef.putFile(File(_selfiePhoto!.path));
    String selfieURL = await selfieUpload.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('kyc').add({
      'userId': userId,
      'frontPhoto': frontURL,
      'backPhoto': backURL,
      'selfiePhoto': selfieURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: _frontPhoto == null
                                ? IconButton(
                                    onPressed: () =>
                                        _selectPhoto(PhotoType.front),
                                    icon: const Icon(Icons.photo_camera),
                                    iconSize: 50,
                                  )
                                : InkWell(
                                    child: Image.file(File(_frontPhoto!.path)),
                                    onTap: () => _selectPhoto(PhotoType.front),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'รูปถ่ายหน้าบัตรประชาชน',
                            style: textTheme().subtitle2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: _backPhoto == null
                                ? IconButton(
                                    onPressed: () =>
                                        _selectPhoto(PhotoType.back),
                                    icon: const Icon(Icons.photo_camera),
                                    iconSize: 50,
                                  )
                                : InkWell(
                                    child: Image.file(File(_backPhoto!.path)),
                                    onTap: () => _selectPhoto(PhotoType.back),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'รูปถ่ายหลังบัตรประชาชน',
                            style: textTheme().subtitle2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: _selfiePhoto == null
                                ? IconButton(
                                    onPressed: () =>
                                        _selectPhoto(PhotoType.selfie),
                                    icon: const Icon(Icons.photo_camera),
                                    iconSize: 50,
                                  )
                                : InkWell(
                                    child: Image.file(File(_selfiePhoto!.path)),
                                    onTap: () => _selectPhoto(PhotoType.selfie),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'รูปถ่ายถือบัตรประชาชนคู่กับใบหน้า',
                            style: textTheme().subtitle2,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'แสดงตัวอย่าง',
                              style: textTheme().bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed:
                            picked ? () => _uploadPhotosAndCreateKYC() : null,
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
                    debugPrint(_frontPhoto!.path.toString());
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
    );
  }
}
