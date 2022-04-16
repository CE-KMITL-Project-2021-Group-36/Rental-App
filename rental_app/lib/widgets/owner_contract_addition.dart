import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/upload_evidence_screen.dart';
import 'package:rental_app/screens/view_contract_screen.dart';
import 'package:rental_app/screens/view_dispute_screen.dart';

ownerContractAddition(context, Contract contract, product, userType) {
  DateTime endDate = contract.endDate.toDate();
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
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
            child: const Text(
              'ดูคำขอเช่า',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
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
            ),
          )
        ],
      );
    case 'รอการชำระ':
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
              const Icon(
                Icons.schedule_outlined,
                color: Colors.grey,
              ),
              Expanded(
                child: Text(
                  'รอผู้เช่าชำระเงินภายใน 24 ชั่วโมงหากไม่ดำเนินการ สัญญาจะถูกยกเลิกอัตโนมัติ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
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
          _buildViewContractButton(context, contract),
        ],
      );
    case 'ที่ต้องได้คืน':
      return Row(
        children: [
          Expanded(
            child: Text(
              'ลูกค้าส่งคืนสินค้าภายใน $formattedEndDate',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          _buildViewContractButton(context, contract),
        ],
      );
    case 'สำเร็จ':
      return Row(
        children: [
          Expanded(
            child: Text(
              'การเช่าสำเร็จ',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          _buildViewContractButton(context, contract),
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
          _buildViewContractButton(context, contract),
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
            child: const Text(
              'ดูข้อพิพาท',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
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
            ),
          )
        ],
      );

    default:
      return const SizedBox.shrink();
  }
}

_buildViewContractButton(context, contract) {
  return TextButton(
    child: const Text(
      'ดูสัญญาเช่า',
      style: TextStyle(
        fontSize: 14,
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadEvidenceScreen(
            contract: contract,
          ),
        ),
      );
    },
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      primary: Colors.white,
      backgroundColor: primaryColor,
    ),
  );
}
