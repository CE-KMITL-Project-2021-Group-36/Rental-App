import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);

  static const String routeName = '/edit_address';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const EditAddressScreen(),
    );
  }

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ที่อยู่ของฉัน'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: users.doc(userId).collection('address').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('บางอย่างผิดพลาด'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Ink(
                          // height: 150,
                          decoration: BoxDecoration(
                              color: primaryLightColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () {},
                            contentPadding: const EdgeInsets.all(15),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: primaryColor,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Wrap(
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '   ' + data['phone'],
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              data['address'],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      child: Text(
                        'เพิ่มที่อยู่ใหม่',
                        style: textTheme().button,
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
