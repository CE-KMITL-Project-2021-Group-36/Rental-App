import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class ContractPayment extends StatefulWidget {
  const ContractPayment({Key? key, required this.amount}) : super(key: key);

  final List<String> amount;

  @override
  State<ContractPayment> createState() => _ContractPaymentState();

  static const String routeName = '/contract_payment';

  static Route route({required List<String> amount}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ContractPayment(amount: amount),
    );
  }
}

class _ContractPaymentState extends State<ContractPayment> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  late final double balance;

  @override
  Widget build(BuildContext context) {
    final double _amount = double.parse(widget.amount.first);
    final String _contractId = widget.amount.last;
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BackButton(),
        ),
        title: const Text('ชำระเงิน'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<DocumentSnapshot>(
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
                      balance = data['wallet']['balance'].toDouble();
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
                                        'ยอดชำระ',
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
                                    '฿' + currencyFormat(_amount),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ยอดเงินคงเหลือ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                                Text(
                                  '฿' + currencyFormat(balance),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
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
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        child: Text(
                          'ชำระเงิน',
                          style: textTheme().button,
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        onPressed: () async {
                          if (balance < _amount) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'จำนวนเงินคงเหลือไม่เพียงพอ'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'ดำเนินการภายหลัง',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(context,
                                                '/wallet_input_passcode',
                                                arguments: 'wallet');
                                          },
                                          child: const Text('เติมเงิน'))
                                    ],
                                  );
                                });
                          } else {
                            final result = await Navigator.pushNamed(
                                context, '/wallet_input_passcode',
                                arguments: 'payment') as bool;
                            if (result == true) {
                              FirebaseFirestore.instance
                                  .collection('contracts')
                                  .doc(_contractId)
                                  .update({
                                'ownerStatus': 'ที่ต้องจัดส่ง',
                                'renterStatus': 'ที่ต้องได้รับ'
                              });
                              final String timestamp =
                                  (DateTime.now().millisecondsSinceEpoch / 1000)
                                      .ceil()
                                      .toString();
                              users
                                  .doc(userId)
                                  .collection('wallet_transactions')
                                  .doc(timestamp)
                                  .set({
                                'amount': _amount,
                                'timestamp': timestamp,
                                'type': 'ชำระเงิน'
                              });
                              users.doc(userId).update({
                                'wallet.balance': FieldValue.increment(-_amount)
                              });
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, '/contract_management',
                                  arguments: ['renter', '2']);
                            }
                          }
                        }),
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
