import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  final _formKey = GlobalKey<FormState>();

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController _amount = TextEditingController();
  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);

  var url =
      Uri.parse('https://srentalapp.vip.ksher.net/api/v1/redirect/orders/');

  Future<void> _onPressedFunction() async {
    if (!_formKey.currentState!.validate()) {
      _continuousValidation.value = true;
    } else {
      debugPrint('Submitting ' + _amount.text);
      final String timestamp =
          ((DateTime.now().toUtc().millisecondsSinceEpoch / 1000).ceil())
              .toString();
      try {
        debugPrint('in try block');
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              <String, String>{
                'amount': '${_amount.text}00',
                'merchant_order_id': '${timestamp}_${_amount.text}00.$userId',
                'redirect_url': 'https://www.google.com',
                'redirect_url_fail': 'https://www.blognone.com',
                'signature': '',
                'timestamp': timestamp,
                'product_name': 'เติมเงินเข้า Renz Wallet',
                'note': 'เติมเงิน ${_amount.text}',
                'lang': 'th'
              },
            ));
        // debugPrint(response.body);
        if (response.statusCode == 200) {
          Map<String, dynamic> postResponse = jsonDecode(response.body);
          final String ksherLink = postResponse['reference'];
          // debugPrint(postResponse.toString());
          debugPrint(ksherLink);
          if (await canLaunchUrlString(ksherLink)) {
            await launchUrlString(
              ksherLink,
              mode: LaunchMode.inAppWebView,
            );
            Navigator.pop(context);
          }
        }
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: Scaffold(
        backgroundColor: surfaceColor,
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: BackButton(),
          ),
          title: const Text('รายละเอียดการเติมเงิน'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final double? balance = data['wallet']?['balance'];
                            return Container(
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
                                      '฿' + currencyFormat(balance!),
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _continuousValidation,
                        builder:
                            (BuildContext context, bool val, Widget? child) {
                          return Form(
                            key: _formKey,
                            autovalidateMode: _continuousValidation.value
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            child: TextFormField(
                              controller: _amount,
                              decoration: const InputDecoration(
                                prefixText: '฿',
                                labelText: 'จำนวนเงิน',
                                helperText: 'ระบุจำนวนเงิน 1 - 100,000 บาท',
                              ),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^0+')),
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (input) {
                                if (!RegExp(
                                        r"""^0*([1-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-8][0-9]{4}|9[0-8][0-9]{3}|99[0-8][0-9]{2}|999[0-8][0-9]|9999[0-9]|100000)$""")
                                    .hasMatch(input!)) {
                                  return 'ระบุจำนวนเงิน 1 - 100,000 บาท เท่านั้น';
                                }
                                return null;
                              },
                            ),
                          );
                        }),
                  ],
                ),
                ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _amount,
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              child: Text(
                                'ดำเนินการต่อ',
                                style: textTheme().button,
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: value.text.isNotEmpty
                                    ? primaryColor
                                    : primaryLightColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              onPressed: value.text.isNotEmpty
                                  ? _onPressedFunction
                                  : null,
                            ),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
