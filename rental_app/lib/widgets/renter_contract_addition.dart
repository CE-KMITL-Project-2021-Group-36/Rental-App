import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/upload_evidence_screen.dart';
import 'package:rental_app/screens/view_contract_screen.dart';
import 'package:rental_app/screens/view_dispute_screen.dart';

renterContractAddition(context, Contract contract, Product product, userType) {
  DateTime endDate = contract.endDate.toDate();
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
  switch (contract.renterStatus) {
    case 'รอการอนุมัติ':
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ค่าเช่าไม่รวมมัดจำ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '฿' + currencyFormat(contract.rentalPrice),
                style: const TextStyle(
                  fontSize: 24,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'ผู้ให้เช่ากำลังทำการตรวจสอบข้อมูลและเอกสารโปรดรอการแจ้งเตือนจากระบบ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              TextButton(
                child: const Text('ดูคำขอเช่า', style: TextStyle(fontSize: 14)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewContractScreen(
                        contract: contract,
                        userType: userType,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  primary: Colors.white,
                  backgroundColor: primaryColor,
                ),
              )
            ],
          ),
        ],
      );
    case 'ที่ต้องชำระ':
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ค่าเช่า'),
              Text('฿' + currencyFormat(contract.rentalPrice))
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ค่ามัดจำ'),
              Text(
                '฿' + currencyFormat(contract.deposit),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                '฿' + currencyFormat(contract.rentalPrice + contract.deposit),
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'ชำระเงินภายใน 24 ชั่วโมงหากไม่ดำเนินการ สัญญาจะถูกยกเลิกอัตโนมัติ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              TextButton(
                child: const Text('ชำระเงินตอนนี้'),
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  primary: Colors.white,
                  backgroundColor: primaryColor,
                  textStyle: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      );
    case 'ที่ต้องได้รับ':
      return Row(
        children: [
          Expanded(
            child: Text(
              'อัปโหลดวิดีโอการเปิดกล่องพัสดุและทำการตรวจสอบสินค้าเพื่อเป็นหลักฐาน',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('ดูสัญญาเช่า'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadEvidenceScreen(
                          contract: contract,
                        )),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              primary: Colors.white,
              backgroundColor: primaryColor,
              textStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      );
    case 'ที่ต้องส่งคืน':
      return Row(
        children: [
          Expanded(
            child: Text(
              'กรุณาส่งคืนสินค้าภายใน $formattedEndDate',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('ดูสัญญาเช่า'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadEvidenceScreen(
                          contract: contract,
                        )),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              primary: Colors.white,
              backgroundColor: primaryColor,
              textStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      );
    case 'ยืนยันจบสัญญา':
      return Row(
        children: [
          Expanded(
            child: Text(
              'ข้าพเจ้ายืนยันว่าสินค้าและการเช่าเป็นไปตามสัญญา และไม่มีปัญหา',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('ยืนยันจบสัญญา'),
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              primary: Colors.white,
              backgroundColor: primaryColor,
              textStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      );
    case 'สำเร็จ':
      return Row(
        children: [
          Expanded(
            child: Text(
              'โปรดให้คะแนนการเช่าครั้งนี้',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('ให้คะแนน'),
            onPressed: () {
              Navigator.pushNamed(context, '/add_review', arguments: product);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              primary: Colors.white,
              backgroundColor: primaryColor,
              textStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      );
    case 'ยกเลิกแล้ว':
      return Row(
        children: [
          Expanded(
            child: Text(
              'ยกเลิกแล้ว',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      );
    case 'ข้อพิพาท':
      return Row(
        children: [
          Expanded(
            child: Text(
              'หากมีข้อสงสัย โปรดติดต่อผู้ดูแลระบบ',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('ดูข้อพิพาท'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewDisputeScreen(
                    contract: contract,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              primary: Colors.white,
              backgroundColor: primaryColor,
              textStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      );

    default:
      return const SizedBox.shrink();
  }
}

showAlertDialog(BuildContext context, Contract contract) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text(
          "ยกเลิก",
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
        child: const Text("ยืนยัน"),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
        onPressed: () async {
          final ref = FirebaseFirestore.instance.collection("contracts").doc(contract.id);
          await ref.update({
            'renterStatus': 'สำเร็จ',
            //'ownerStatus': 'ยกเลิกแล้ว',
          });
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("ยืนยันการจบสัญญาเช่านี้?"),
        content: const Text("คุณได้ส่งของคืนแก่ผู้ให้เช่าเรียบร้อยแล้ว"),
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