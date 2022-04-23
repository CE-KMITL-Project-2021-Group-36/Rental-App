import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/providers/authentication_provider.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/edit_profile';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EditProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final _auth = ref.watch(authenticationProvider);

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
            final String displayName =
                    '${data['firstName']} ${data['lastName']}',
                avatarUrl = data['avatarUrl'] ??=
                    'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4';

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
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              avatarUrl,
                            ),
                          ),
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
                                onPressed: () {},
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
                        onTap: () {},
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
                                      'โทรศัพท์มือถือ',
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
                        onTap: () {},
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
                          Navigator.of(context).pushReplacementNamed('/');
                          _auth.signOut();
                          //showdialog confirm deletion
                        },
                        child: Ink(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent.shade100,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'ลบบัญชี',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
