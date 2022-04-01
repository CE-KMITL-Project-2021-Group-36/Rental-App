import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/view_contract_screen.dart';
import 'package:rental_app/screens/upload_evidence_screen.dart';

class ContractCard extends StatelessWidget {
  const ContractCard({
    Key? key,
    required this.contract,
  }) : super(key: key);
  final Contract contract;

  @override
  Widget build(BuildContext context) {
    DateTime startDate = contract.startDate.toDate();
    DateTime endDate = contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("products")
            .doc(contract.productId)
            .get(),
        builder: (context, snapshot) {
          final product = snapshot.data;
          return product != null
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                      '฿' + contract.rentalPrice.toStringAsFixed(0),
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
                      _buildAction(contract.status, context),
                    ],
                  ),
                )
              : const Text('Error No Product');
        });
  }

  Widget _buildAction(String type, context) {
    switch (type) {
      case 'รอการอนุมัติ':
        return Row(
          children: [
            Expanded(
              child: Text(
                'ผู้ให้เช่ากำลังทำการตรวจสอบข้อมูลและเอกสารโปรดรอการแจ้งเตือนจากระบบ',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            TextButton(
              child: const Text('ดูคำขอเช่า'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewContractScreen()),
                );
              },
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
        );
      case 'ที่ต้องชำระ':
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
        );
      case 'ที่ต้องได้รับ':
        return Row(
          children: [
            Expanded(
              child: Text(
                'กรุณากดปุ่มเพื่ออัปโหลดวิดีโอการเปิดกล่องพัสดุและทำการตรวจสอบสินค้าอย่างละเอียดเพื่อเป็นหลักฐาน',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            TextButton(
              child: const Text('หลักฐานเปิดกล่องพัสดุ'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadEvidenceScreen()),
                );
              },
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
        );
      case 'ที่ต้องส่งคืน':
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
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
