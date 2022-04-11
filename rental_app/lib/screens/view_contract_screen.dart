import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ViewContractScreen extends StatefulWidget {
  const ViewContractScreen(
      {Key? key, required this.contract, required this.userType})
      : super(key: key);

  @override
  State<ViewContractScreen> createState() => _ViewContractScreenState();
  final Contract contract;
  final String userType;
}

class _ViewContractScreenState extends State<ViewContractScreen> {
  CollectionReference contracts =
      FirebaseFirestore.instance.collection("contracts");
  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.contract.startDate.toDate();
    DateTime endDate = widget.contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);

    double inputDeposit = 0;

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text(
          "ไม่ยกเลิก",
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        style: TextButton.styleFrom(
          //primary: errorColor,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text("ยกเลิกคำขอเช่า"),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
        onPressed: () async {
          final ref = contracts.doc(widget.contract.id);
          await ref.update({
            'renterStatus': 'ยกเลิกแล้ว',
            'ownerStatus': 'ยกเลิกแล้ว',
          });
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('ยกเลิกคำขอเช่าแล้ว'),
          ));
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("คุณต้องการยกเลิกคำขอเช่านี้?"),
        //content: const Text("คุณต้องการยกเลิกคำขอเช่านี้"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('คำขอเช่า'),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("products")
              .doc(widget.contract.productId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final product = snapshot.data;
            return product != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: outlineColor,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, color: Colors.white),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'รอการอนุมัติ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'โปรดตรวจสอบข้อมูลและเอกสารอย่างละเอียด'
                                          .replaceAll('\\n', '\n'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: outlineColor,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox.fromSize(
                                        child: Image.network(
                                          product['imageUrl'],
                                          fit: BoxFit.cover,
                                          height: 100.0,
                                          width: 100.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'เช่าวันที่ $formattedStartDate ถึง $formattedEndDate',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'ค่าเช่าไม่รวมมัดจำ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '฿' +
                                                    currencyFormat(widget.contract.rentalPrice),
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(thickness: 0.6, height: 32),
                                const Text(
                                  'เงื่อนไขค่ามัดจำ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product['deposit'].replaceAll('\\n', '\n'),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'เอกสารแนบเพิ่มเติม',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.contract.imageUrls.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Ink.image(
                                  image: NetworkImage(
                                      widget.contract.imageUrls[index]),
                                  fit: BoxFit.cover,
                                  child: InkWell(
                                    onTap: () {
                                      //Go to ImageView
                                    },
                                  ),
                                );
                              }),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: outlineColor,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'ที่อยู่',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'วัชรากร แท่นแก้ว'.replaceAll('\\n', '\n'),
                                ),
                                Text(
                                  '086-123-1669'.replaceAll('\\n', '\n'),
                                ),
                                Text(
                                  '9/1 ถ.พหลโยธิน 35 แขวงลาดยาว\nเขตจตุจักร, จังหวัดกรุงเทพมหานคร, 10900'
                                      .replaceAll('\\n', '\n'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          widget.userType == 'renter'
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              showAlertDialog(context);
                                            },
                                            child: const Text('ยกเลิกคำขอเช่า'),
                                            style: TextButton.styleFrom(
                                              primary: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: const BorderSide(
                                                    color: primaryColor,
                                                    width: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () async {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.chat_bubble_rounded),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text('ติดต่อผู้ให้เช่า'),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(thickness: 0.6, height: 32),
                                    const Text(
                                      'ระบุค่าเช่า',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      onChanged: (text) {
                                        if (text.isNotEmpty) {
                                          inputDeposit = double.parse(text);
                                          //setState(() {});
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'ใส่จำนวนค่ามัดจำ',
                                        suffix: Text('บาท'),
                                        alignLabelWithHint: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'จัดการคำขอเช่า',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('ค่าเช่า'),
                                        Text('฿' +
                                            currencyFormat(widget.contract.rentalPrice)
                                                )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('ค่ามัดจำ'),
                                        Text(
                                          '฿' + currencyFormat(inputDeposit),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'ยอดรวมทั้งหมด',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '฿' +
                                              currencyFormat(widget.contract.rentalPrice +
                                                      inputDeposit),
                                          style: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(children: <Widget>[
                                      TextButton(
                                        onPressed: () {},
                                        child: const SizedBox(
                                          width: 140,
                                          child: Center(child: Text("ปฎิเสธ")),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: primaryColor,
                                          //backgroundColor: primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: const BorderSide(
                                                color: primaryColor, width: 1),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            contracts
                                                .doc(widget.contract.id)
                                                .update({
                                                  'renterStatus': 'ที่ต้องชำระ',
                                                  'ownerStatus': 'รอการชำระ',
                                                  'deposit': inputDeposit,
                                                })
                                                .then((value) =>
                                                    print('Contract Update'))
                                                .catchError((error) => print(
                                                    'Failed to update contract: $error'));
                                            Navigator.pop(context);
                                          },
                                          child: const Text("อนุมัติ"),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}