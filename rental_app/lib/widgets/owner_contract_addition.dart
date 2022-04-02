import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/upload_evidence_screen.dart';
import 'package:rental_app/screens/view_contract_screen.dart';

ownerContractAddition(context, Contract contract, userType) {
  switch (contract.ownerStatus) {
    case 'รอการอนุมัติ':
      return Row(
        children: [
          Expanded(
            child: Text(
              'โปรดตรวจสอบข้อมูลและเอกสารอย่างละเอียด',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('ดูคำขอเช่า'),
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
    case 'รอการชำระ':
      return Row(
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
    case 'ที่ต้องจัดส่ง':
      return Row(
        children: [
          Expanded(
            child: Text(
              'กรุณากดปุ่มเพื่ออัปโหลดวิดีโอการเปิดกล่องพัสดุและทำการตรวจสอบสินค้าอย่างละเอียดเพื่อเป็นหลักฐาน',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('หลักฐานการส่งพัสดุ'),
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
    case 'ที่ต้องได้รับ':
      return Row(
        children: [
          Expanded(
            child: Text(
              'กรุณาส่งคืนสินค้าภายใน 12:00 น. 15 ม.ค. 64',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            child: const Text('หลักฐานเปิดกล่องพัสดุ'),
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
            child: const Text('ดำเนินการต่อ'),
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

    default:
      return const SizedBox.shrink();
  }
}
