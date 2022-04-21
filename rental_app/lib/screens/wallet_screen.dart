import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

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
    final Stream<QuerySnapshot> _walletTransactionStream =
        users.doc(userId).collection('wallet_transactions').snapshots();

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BackButton(),
        ),
        centerTitle: false,
        title: const Text('Wallet'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: StreamBuilder<DocumentSnapshot>(
              stream: users.doc(userId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('มีบางอย่างผิดพลาด'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              '฿' +
                                  currencyFormat(snapshot.data.data()['wallet']
                                      ['balance']),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/wallet_request_withdrawal');
                            },
                            child: Ink(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: backgroundColor,
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
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/wallet_top_up');
                            },
                            child: Ink(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    size: 40,
                                    color: surfaceColor,
                                  ),
                                  Text(
                                    'เติมเงิน  ',
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
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        ' รายการล่าสุด',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54),
                      ),
                    ),
                    // StreamBuilder<QuerySnapshot>(
                    //   stream: _walletTransactionStream,
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<QuerySnapshot> snapshot) {
                    //     if (snapshot.hasError) {
                    //       return const Center(child: Text('มีบางอย่างผิดพลาด'));
                    //     }
                    //
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //
                    //     return Expanded(
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             color: backgroundColor,
                    //             borderRadius: BorderRadius.circular(10)),
                    //         child: ListView(
                    //           children: snapshot.data!.docs
                    //               .map((DocumentSnapshot document) {
                    //             Map<String, dynamic> data =
                    //                 document.data()! as Map<String, dynamic>;
                    //             final String type = data['type'];
                    //             return ListTile(
                    //               title: Text(type),
                    //               subtitle: Text(data['timestamp']),
                    //               trailing: Text(
                    //                 data['amount'].toString(),
                    //                 style: TextStyle(
                    //                   color: type == 'เติมเงิน'
                    //                       ? successColor
                    //                       : errorColor,
                    //                   fontSize: 24,
                    //                 ),
                    //               ),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: FirestoreListView(
                            pageSize: 10,
                            query: users
                                .doc(userId)
                                .collection('wallet_transactions')
                                .orderBy('timestamp', descending: true),
                            itemBuilder: (context, snapshot) {
                              Map<String, dynamic> data =
                                  snapshot.data()! as Map<String, dynamic>;
                              final String type = data['type'];
                              late String amount;
                              final DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(data['timestamp']) * 1000);
                              if (type.contains('เติมเงิน') == true ||
                                  type.contains('ได้รับเงิน') == true) {
                                amount = '+ ${data['amount']}';
                              } else {
                                amount = '- ${data['amount']}';
                              }
                              return ListTile(
                                title: Text(type),
                                subtitle: Text(DateFormat('dd-MM-yyyy    hh:mm')
                                    .format(date)),
                                trailing: Text(
                                  amount,
                                  style: TextStyle(
                                    color: type.contains('เติมเงิน') == true ||
                                            type.contains('ได้รับเงิน') == true
                                        ? secondaryColor
                                        : errorColor,
                                    fontSize: 24,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
