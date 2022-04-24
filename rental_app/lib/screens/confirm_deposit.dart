import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';

class ConfirmDeposit extends StatelessWidget {
  const ConfirmDeposit(
      {Key? key,
      required this.contract,
      required this.deposit,
      required this.productName})
      : super(key: key);
  final Contract contract;
  final double deposit;
  final String productName;

  @override
  Widget build(BuildContext context) {
    debugPrint('ค่ามัดจำ: ${contract.deposit}');
    CollectionReference contracts =
        FirebaseFirestore.instance.collection("contracts");
    return Scaffold(
      appBar: AppBar(
        title: const Text('ยืนยันค่ามัดจำ'),
      ),
      backgroundColor: surfaceColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ค่าเช่า'),
                Text(
                  '฿' + currencyFormat(contract.rentalPrice),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ค่ามัดจำ'),
                Text(
                  '฿' + currencyFormat(deposit),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ยอดรวมทั้งหมด',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '฿' + currencyFormat(contract.rentalPrice + deposit),
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    width: 120,
                    child: Center(child: Text("ย้อนกลับ")),
                  ),
                  style: TextButton.styleFrom(
                    primary: primaryColor,
                    //backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: primaryColor, width: 1),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      sendNotification(
                        contract.renterId,
                        'กรุณาชำระค่าเช่า',
                        'รายการ: $productName',
                        'renter',
                      );
                      contracts
                          .doc(contract.id)
                          .update({
                            'renterStatus': 'ที่ต้องชำระ',
                            'ownerStatus': 'รอการชำระ',
                            'deposit': deposit,
                          })
                          .then((value) => debugPrint('Contract Update'))
                          .catchError((error) =>
                              debugPrint('Failed to update contract: $error'));
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                    child: const Text("ยืนยันและสร้างสัญญา"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
