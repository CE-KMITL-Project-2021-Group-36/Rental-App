import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class WalletRequestWithdrawal extends StatefulWidget {
  const WalletRequestWithdrawal({Key? key}) : super(key: key);

  @override
  State<WalletRequestWithdrawal> createState() =>
      _WalletRequestWithdrawalState();

  static const String routeName = '/wallet_request_withdrawal';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const WalletRequestWithdrawal(),
    );
  }
}

class _WalletRequestWithdrawalState extends State<WalletRequestWithdrawal> {
  final _formBankAccount = GlobalKey<FormState>();
  final _formPromptpay = GlobalKey<FormState>();

  final userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _accountNumber = TextEditingController();
  final TextEditingController _promptpayNumber = TextEditingController();
  final ValueNotifier<bool> _continuousValidation = ValueNotifier(false);
  final ValueNotifier<int> _currentTabIndex = ValueNotifier(0);

  late final String _fullName, _timestamp;
  late final double _balance;
  late String? selectedBank;

  final List<String> bankList = [
    'กสิกรไทย',
    'กรุงไทย',
    'กรุงเทพ',
    'ทีทีบี',
    'ออมสิน',
    'กรุงศรี',
    'ธ.ก.ส.',
    'ยูโอบี',
    'อาคารสงเคราะห์',
    'ซีไอเอ็มบี',
    'ซิตี้แบงก์',
    'ดอยซ์แบงก์',
    'เอชเอสบีซี',
    'ไอซีบีซี',
    'ธนาคารอิสลาม',
    'เกียรตินาคินภัทร',
    'แลนด์แอนด์เฮาส์',
    'มิซูโฮ',
    'สแตนดาร์ดชาร์เตอร์ด',
    'ซูมิโตโม',
    'ไทยเครดิต',
    'ทิสโก้',
  ];

  @override
  Widget build(BuildContext context) {
    Future<void> _onPressedFunction() async {
      //Bank Account
      if (_currentTabIndex.value == 0) {
        if (!_formBankAccount.currentState!.validate()) {
          _continuousValidation.value = true;
        } else {
          Navigator.pop(context);
          _timestamp =
              (DateTime.now().millisecondsSinceEpoch / 1000).ceil().toString();
          debugPrint('Submitting: ' +
              _amount.text +
              ' page: ' +
              _currentTabIndex.value.toString());
          await FirebaseFirestore.instance
              .collection('withdrawal_requests')
              .add({
            'type': 'บัญชีธนาคาร',
            'fullName': _fullName,
            'userId': userId,
            'destination': _accountNumber.text,
            'bank': selectedBank,
            'amount': _amount.text,
            'timestamp': FieldValue.serverTimestamp(),
          });
          await users
              .doc(userId)
              .collection('wallet_transactions')
              .doc(_timestamp)
              .set({
            'amount': _amount.text,
            'type': 'ถอนเงิน',
            'timestamp': _timestamp
          });
          await users.doc(userId).update({
            'wallet.balance': FieldValue.increment(-double.parse(_amount.text))
          });
        }
      }
      //PromptPay
      if (_currentTabIndex.value == 1) {
        if (!_formPromptpay.currentState!.validate()) {
          _continuousValidation.value = true;
        } else {
          Navigator.pop(context);
          _timestamp =
              (DateTime.now().millisecondsSinceEpoch / 1000).ceil().toString();
          debugPrint('Submitting: ' +
              _amount.text +
              ' page: ' +
              _currentTabIndex.value.toString());
          await FirebaseFirestore.instance
              .collection('withdrawal_requests')
              .add({
            'type': 'พร้อมเพย์',
            'fullName': _fullName,
            'userId': userId,
            'destination': _promptpayNumber.text,
            'amount': _amount.text,
            'timestamp': _timestamp,
          });
          await users
              .doc(userId)
              .collection('wallet_transactions')
              .doc(_timestamp)
              .set({
            'amount': _amount.text,
            'type': 'ถอนเงิน',
            'timestamp': _timestamp
          });
          await users.doc(userId).update({
            'wallet.balance': FieldValue.increment(-double.parse(_amount.text))
          });
        }
      }
    }

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateAnyDirection,
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => debugPrint(currentTabIndex.toString()),
          // ),
          backgroundColor: surfaceColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BackButton(),
            ),
            centerTitle: false,
            title: const Text('รายละเอียดคำขอถอนเงิน'),
          ),
          body: SafeArea(
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
                            _balance = data['wallet']['balance'];
                            _fullName =
                                '${data['firstName']} ${data['lastName']}';
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                                      '฿' + currencyFormat(_balance),
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
                    SizedBox(
                      height: 50,
                      child: AppBar(
                        backgroundColor: backgroundColor,
                        bottom: TabBar(
                          labelColor: primaryColor,
                          unselectedLabelColor: Colors.black54,
                          tabs: const [
                            Tab(
                              text: 'บัญชีธนาคาร',
                            ),
                            Tab(
                              text: 'พร้อมเพย์',
                            ),
                          ],
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          onTap: (index) {
                            _currentTabIndex.value = index;
                            _continuousValidation.value = false;
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: backgroundColor,
                      height: 335,
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ValueListenableBuilder(
                                  valueListenable: _continuousValidation,
                                  builder: (BuildContext context, bool val,
                                      Widget? child) {
                                    return Form(
                                      key: _formBankAccount,
                                      autovalidateMode: _continuousValidation
                                              .value
                                          ? AutovalidateMode.onUserInteraction
                                          : AutovalidateMode.disabled,
                                      child: Column(
                                        children: [
                                          DropdownButtonFormField2(
                                            items: bankList
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        )))
                                                .toList(),
                                            hint: const Text('เลือกธนาคาร'),
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            dropdownMaxHeight: 300,
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 30,
                                            ),
                                            validator: (value) {
                                              if (value == null) {
                                                return 'โปรดเลือกธนาคาร';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              selectedBank = value.toString();
                                              debugPrint(selectedBank);
                                            },
                                            // onSaved: (value) {
                                            //   selectedValue = value.toString();
                                            // },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            controller: _accountNumber,
                                            decoration: const InputDecoration(
                                              labelText: 'เลขที่บัญชี',
                                              counterText: '',
                                            ),
                                            autocorrect: false,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            maxLength: 10,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            validator: (input) {
                                              if (input!.isEmpty) {
                                                return 'โปรดระบุเลขที่บัญชี';
                                              } else if (input.length < 10) {
                                                return 'เลขที่บัญชีไม่ถูกต้อง';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            controller: _amount,
                                            decoration: const InputDecoration(
                                              prefixText: '฿',
                                              labelText: 'จำนวนเงิน',
                                              helperText:
                                                  'ระบุจำนวนเงิน 1 - 100,000 บาท',
                                            ),
                                            autocorrect: false,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp(r'^0+')),
                                              LengthLimitingTextInputFormatter(
                                                  6),
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (input) {
                                              if (_amount.text != '') {
                                                if ((double.parse(
                                                        _amount.text) >
                                                    _balance)) {
                                                  return 'จำนวนเงินในบัญชีไม่เพียงพอ';
                                                }
                                              }
                                              if (!RegExp(
                                                      r"""^0*([1-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-8][0-9]{4}|9[0-8][0-9]{3}|99[0-8][0-9]{2}|999[0-8][0-9]|9999[0-9]|100000)$""")
                                                  .hasMatch(input!)) {
                                                return 'ระบุจำนวนเงิน 1 - 100,000 บาท เท่านั้น';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ValueListenableBuilder(
                                  valueListenable: _continuousValidation,
                                  builder: (BuildContext context, bool val,
                                      Widget? child) {
                                    return Form(
                                      key: _formPromptpay,
                                      autovalidateMode: _continuousValidation
                                              .value
                                          ? AutovalidateMode.onUserInteraction
                                          : AutovalidateMode.disabled,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _promptpayNumber,
                                            decoration: const InputDecoration(
                                              labelText: 'หมายเลขพร้อมเพย์',
                                              counterText: '',
                                            ),
                                            autocorrect: false,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            maxLength: 13,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            validator: (input) {
                                              if (input!.isEmpty) {
                                                return 'โปรดระบุหมายเลขพร้อมเพย์';
                                              } else if (input.length < 10 ||
                                                  (input.length > 10 &&
                                                      input.length < 13)) {
                                                return 'หมายเลขพร้อมเพย์ไม่ถูกต้อง';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            controller: _amount,
                                            decoration: const InputDecoration(
                                              prefixText: '฿',
                                              labelText: 'จำนวนเงิน',
                                              helperText:
                                                  'ระบุจำนวนเงิน 1 - 100,000 บาท',
                                            ),
                                            autocorrect: false,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp(r'^0+')),
                                              LengthLimitingTextInputFormatter(
                                                  6),
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (input) {
                                              if (_amount.text != '') {
                                                if ((double.parse(
                                                        _amount.text) >
                                                    _balance)) {
                                                  return 'จำนวนเงินในบัญชีไม่เพียงพอ';
                                                }
                                              }
                                              if (!RegExp(
                                                      r"""^0*([1-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-8][0-9]{4}|9[0-8][0-9]{3}|99[0-8][0-9]{2}|999[0-8][0-9]|9999[0-9]|100000)$""")
                                                  .hasMatch(input!)) {
                                                return 'ระบุจำนวนเงิน 1 - 100,000 บาท เท่านั้น';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ]),
                    ),
                  ],
                ),
                ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _amount,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                        ),
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
