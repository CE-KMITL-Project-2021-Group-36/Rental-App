import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();

  static const String routeName = '/wallet';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const Wallet(),
    );
  }
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BackButton(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<DocumentSnapshot>(
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
                  final double? balance = data['wallet']?['balance'];
                  return Column(
                    children: [
                      Container(
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
                                    'ยอดเงินคงเหลือ',
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
                              bottom: 10,
                              right: 10,
                              child: Text(
                                '฿ $balance',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
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
                                    'ยอดเงินคงเหลือ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              top: 10,
                              left: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: primaryColor, width: 2)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.payments,
                                    size: 40,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    'ถอนเงิน',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {},
                              child: Ink(
                                height: 75,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      size: 40,
                                      color: surfaceColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'เติมเงิน',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: surfaceColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
