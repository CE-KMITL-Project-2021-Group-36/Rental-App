import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';

class OwnerAccountScreen extends ConsumerWidget {
  const OwnerAccountScreen({Key? key}) : super(key: key);

  static const String routeName = '/owner_account';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const OwnerAccountScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final CollectionReference contracts =
        FirebaseFirestore.instance.collection('contracts');

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
            final String shopName = data['shop']['shopName'];
            final String avatarUrl = data['avatarUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4';

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
                          bottom: 32,
                          left: 95,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.storefront,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                shopName,
                                style: const TextStyle(
                                  color: primaryLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 50,
                          left: 16,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Theme.of(context).platform ==
                                      TargetPlatform.android
                                  ? const Icon(
                                      Icons.arrow_back,
                                      size: 24,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.arrow_back_ios,
                                      size: 24,
                                      color: Colors.white,
                                    )),
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
                                        'สัญญาที่ให้เช่า',
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
                                          arguments: ['owner', '0']);
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
                                  left: 5,
                                  right: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('ownerId',
                                                    isEqualTo: userId)
                                                .where('ownerStatus',
                                                    isEqualTo: 'รอการอนุมัติ')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int
                                                  waitingForApprovalCount =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        '/contract_management',
                                                        arguments: [
                                                      'owner',
                                                      '0'
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons
                                                            .clipboardQuestion,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$waitingForApprovalCount'),
                                                      showBadge:
                                                          waitingForApprovalCount >
                                                                  0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'รอการอนุมัติ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('ownerId',
                                                    isEqualTo: userId)
                                                .where('ownerStatus',
                                                    isEqualTo: 'รอการชำระ')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int waitingForPaymentCount =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        '/contract_management',
                                                        arguments: [
                                                      'owner',
                                                      '1'
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons.wallet,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$waitingForPaymentCount'),
                                                      showBadge:
                                                          waitingForPaymentCount >
                                                                  0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'รอการชำระ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('ownerId',
                                                    isEqualTo: userId)
                                                .where('ownerStatus',
                                                    isEqualTo: 'ที่ต้องจัดส่ง')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int readyToShipCount =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        '/contract_management',
                                                        arguments: [
                                                      'owner',
                                                      '2'
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons.box,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$readyToShipCount'),
                                                      showBadge:
                                                          readyToShipCount > 0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'ที่ต้องจัดส่ง',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('ownerId',
                                                    isEqualTo: userId)
                                                .where('ownerStatus',
                                                    isEqualTo: 'ที่ต้องได้คืน')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int toReceiveCount =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        '/contract_management',
                                                        arguments: [
                                                      'owner',
                                                      '3'
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons.truck,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$toReceiveCount'),
                                                      showBadge:
                                                          toReceiveCount > 0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'ที่ต้องได้คืน',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('ownerId',
                                                    isEqualTo: userId)
                                                .where('ownerStatus',
                                                    isEqualTo: 'ข้อพิพาท')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int disputeCount =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        '/contract_management',
                                                        arguments: [
                                                      'owner',
                                                      '6'
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        Icons.gavel,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent:
                                                          Text('$disputeCount'),
                                                      showBadge:
                                                          disputeCount > 0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'ข้อพิพาท',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
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
                              Navigator.pushNamed(context, '/add_product');
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
                                          Icons.add_circle,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'เพิ่มสินค้า',
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
                              Navigator.pushNamed(
                                context,
                                '/product_management',
                              );
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
                                          FontAwesomeIcons.box,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'จัดการสินค้า',
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
                              Navigator.pushNamed(
                                context,
                                '/edit_shop',
                              );
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
                                          'แก้ไขข้อมูลร้าน',
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
                              Navigator.pushNamed(
                                context,
                                '/shop',
                                arguments: userId,
                              );
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
                                          Icons.storefront_rounded,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'ดูหน้าร้านค้า',
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
