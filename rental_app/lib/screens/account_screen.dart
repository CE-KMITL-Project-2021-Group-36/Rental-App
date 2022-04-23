import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/providers/authentication_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
                kycStatus = data['kyc']['status'],
                avatarUrl = data['avatarUrl'] ??=
                    'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4';
            final double? balance = data['wallet']?['balance'];
            final bool kycVerified = data['kyc']['verified'];

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 175,
                          color: primaryColor,
                        ),
                        Positioned(
                          top: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/user_store');
                            },
                            child: Row(
                              children: [
                                Text(
                                  'ร้านของฉัน',
                                  style: textTheme().bodyText2,
                                ),
                                const Icon(Icons.chevron_right)
                              ],
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 3.0, 5.0, 3.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              primary: textColor,
                              backgroundColor: primaryLightColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 20,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              avatarUrl,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 95,
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              color: primaryLightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 22,
                          left: 95,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              kycStatus,
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              primary:
                                  kycVerified ? textColor : primaryLightColor,
                              backgroundColor:
                                  kycVerified ? secondaryColor : errorColor,
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 3.0, 10.0, 3.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Row(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.clipboardList,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'สัญญาเช่า',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  top: 10,
                                  left: 10,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/contract_management',
                                          arguments: 'renter');
                                    },
                                    child: Row(
                                      children: const [
                                        Text(
                                          'ดูทั้งหมด',
                                        ),
                                        Icon(Icons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 55,
                                  left: 10,
                                  right: 10,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: const [
                                            Icon(FontAwesomeIcons
                                                .clipboardQuestion),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'รอการอนุมัติ',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: const [
                                            Icon(FontAwesomeIcons.wallet),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'ที่ต้องชำระ',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: const [
                                            Icon(FontAwesomeIcons.truck),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'ที่ต้องได้รับ',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: const [
                                            Icon(FontAwesomeIcons.box),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'ที่ต้องส่งคืน',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: const [
                                            Icon(FontAwesomeIcons
                                                .clipboardCheck),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'ยืนยันจบสัญญา',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/wallet_input_passcode');
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.wallet,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Wallet',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    top: 10,
                                    left: 10,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Row(
                                      children: const [
                                        Text(
                                          'ดูรายละเอียด',
                                        ),
                                        Icon(Icons.chevron_right)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Text(
                                      balance != null
                                          ? '฿' + currencyFormat(balance)
                                          : '฿ 0.00',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.solidHeart,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'สิ่งที่ฉันถูกใจ',
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
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/kyc');
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.userCheck,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'ยืนยันตัวตน',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(kycStatus),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/edit_profile');
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.pen,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'แก้ไขข้อมูล และจัดการบัญชี',
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
                            height: 5,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.announcement,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'รายงานปัญหา',
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
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/');
                              _auth.signOut();
                            },
                            child: Ink(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  // color: Colors.redAccent.shade100,
                                  border: Border.all(
                                    color: Colors.redAccent.shade100,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      Icons.logout,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ออกจากระบบ',
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
                  ],
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
