import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class WalletTopUp extends StatefulWidget {
  const WalletTopUp({Key? key}) : super(key: key);

  @override
  State<WalletTopUp> createState() => _WalletTopUpState();

  static const String routeName = '/wallet_top_up';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const WalletTopUp(),
    );
  }
}

class _WalletTopUpState extends State<WalletTopUp> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final TextEditingController _amount = TextEditingController();

    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: BackButton(),
          ),
          centerTitle: false,
          title: const Text('รายละเอียดการเติมเงิน'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _amount,
                              decoration: const InputDecoration(
                                labelText: 'จำนวนเงิน',
                              ),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              validator: (input) {
                                if (input!.isEmpty) return 'โปรดระบุจำนวนเงิน';
                                return null;
                              },
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  child: Text(
                                    'ดำเนินการต่อ',
                                    style: textTheme().button,
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: _amount != null
                                        ? primaryColor
                                        : primaryLightColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
