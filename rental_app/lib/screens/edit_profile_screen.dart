import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_app/config/palette.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/edit_profile';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EditProfileScreen(),
    );
  }

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool picked = false;
  XFile? _profilePhoto;
  final ImagePicker _picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late final String displayName, phoneNumber;
  final ValueNotifier<String> avatarUrl = ValueNotifier(
      'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4');

  Future _selectPhoto() async {
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
                      _pickPhoto(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('เลือกจากคลัง'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      _pickPhoto(ImageSource.gallery);
                    },
                  )
                ],
              ),
            ));
  }

  Future _pickPhoto(ImageSource source) async {
    XFile? photo = await _picker.pickImage(source: source);

    _profilePhoto = photo;
    debugPrint(_profilePhoto!.path);
    _uploadProfilePhoto();
  }

  Future _uploadProfilePhoto() async {
    final profilePhotoRef =
        FirebaseStorage.instance.ref().child('profile/$userId');
    final profilePhotoUpload =
        await profilePhotoRef.putFile(File(_profilePhoto!.path));
    avatarUrl.value = await profilePhotoUpload.ref.getDownloadURL();
    debugPrint(avatarUrl.value);

    await users.doc(userId).update(
      {'avatarUrl': avatarUrl.value},
    );
    // setState(() {
    //   picked = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _deleteUser() {
      return users.doc(userId).delete().then((value) => FirebaseAuth
          .instance.currentUser
          ?.delete()
          .then((value) => Navigator.of(context).pushReplacementNamed('/')));
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ข้อมูลผิดพลาด");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("ไม่พบข้อมูล");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            displayName = '${data['firstName']} ${data['lastName']}';
            avatarUrl.value = data['avatarUrl'] ??=
                'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4';
            phoneNumber = data['phoneNumber'];

            return Scaffold(
              appBar: AppBar(
                title: const Text('ข้อมูลส่วนตัวและบัญชี'),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ValueListenableBuilder(
                              valueListenable: avatarUrl,
                              builder: (context, value, child) {
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    avatarUrl.value,
                                  ),
                                );
                              }),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: _selectPhoto,
                                child: const Text(
                                  'แก้ไขรูปภาพ',
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.black87,
                                  backgroundColor: warningColor,
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 5.0, 10.0, 5.0),
                                  minimumSize: Size.zero,
                                  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit_address');
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Ink(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.location_on,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ที่อยู่ของฉัน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit_phone',
                              arguments: phoneNumber);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Ink(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.phone,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'เบอร์โทรศัพท์',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/reset_password');
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Ink(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.lock,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'เปลี่ยนรหัสผ่าน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/wallet_init_passcode');
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Ink(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'เปลี่ยนรหัสผ่าน Wallet',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             title: const Text(
                      //                 'คุณต้องการลบบัญชีและข้อมูลทั้งหมดใช่หรือไม่'),
                      //             actions: [
                      //               TextButton(
                      //                   onPressed: () {
                      //                     Navigator.pop(context);
                      //                   },
                      //                   child: const Text(
                      //                     'ยกเลิก',
                      //                     style:
                      //                         TextStyle(color: Colors.black54),
                      //                   )),
                      //               TextButton(
                      //                   onPressed: _deleteUser,
                      //                   child: const Text(
                      //                     'ยืนยัน',
                      //                     style: TextStyle(color: errorColor),
                      //                   )),
                      //             ],
                      //           );
                      //         });
                      //   },
                      //   child: Ink(
                      //     width: double.infinity,
                      //     height: 45,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: Colors.redAccent.shade100,
                      //           width: 1.5,
                      //         ),
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 10),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: const [
                      //           Icon(
                      //             Icons.delete,
                      //             size: 20,
                      //           ),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Text(
                      //             'ลบบัญชี',
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
