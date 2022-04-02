import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';

class UploadEvidenceScreen extends StatefulWidget {
  const UploadEvidenceScreen({Key? key, required this.contract})
      : super(key: key);
  @override
  State<UploadEvidenceScreen> createState() => _UploadEvidenceScreenState();

  final Contract contract;
}

class _UploadEvidenceScreenState extends State<UploadEvidenceScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.contract.startDate.toDate();
    DateTime endDate = widget.contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำขอเช่า'),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(widget.contract.productId)
              .get(),
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
            return product == null
                ? const SizedBox.shrink()
                : SingleChildScrollView(
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
                                const Icon(Icons.videocam, color: Colors.white),
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
                                          'ที่ต้องได้รับ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'กรุณาถ่ายและอัปโหลดวิดีโอการเปิดกล่องพัสดุ'
                                          .replaceAll('\\n', '\n'),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
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
                                                    widget.contract.rentalPrice
                                                        .toStringAsFixed(0),
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
                          const Text(
                            'ค่าเช่าทั้งหมด',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ค่าเช่า',
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '฿' +
                                    widget.contract.rentalPrice
                                        .toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 18,
                                  // color: primaryColor,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ค่ามัดจำ',
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '฿' +
                                    widget.contract.deposit.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 18,
                                  // color: primaryColor,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ยอดรวมทั้งหมด',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                '฿' +
                                    (widget.contract.rentalPrice +
                                            widget.contract.deposit)
                                        .toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.6, height: 32),
                          const Text(
                            'วิด๊โอรับสินค้า',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'เมื่อได้รับ - เปิดกล่องพัสดุและตรวจสอบสินค้าอย่างละเอียด',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 140,
                            height: 140,
                            child: InkWell(
                              splashColor: primaryColor,
                              onTap: () {},
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: primaryColor[50],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const Icon(Icons.videocam,
                                    color: primaryColor, size: 60),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(thickness: 0.6, height: 32),
                          const Text(
                            'วิด๊โอหลักฐาน',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'เมื่อส่งคืน - ตรวจสอบสินค้าอย่างละเอียดและนำส่งพัสดุ',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 140,
                            height: 140,
                            child: InkWell(
                              splashColor: primaryColor,
                              onTap: () {},
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: primaryColor[50],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const Icon(Icons.videocam,
                                    color: primaryColor, size: 60),
                              ),
                            ),
                          ),
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
                                      'ส่งคืนที่อยู่',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ภูริวัจน์ วิจิตธัญโรจน์'
                                      .replaceAll('\\n', '\n'),
                                ),
                                Text(
                                  '0837476791'.replaceAll('\\n', '\n'),
                                ),
                                Text(
                                  '123/2 ซ.ฉลองกรุง 1, ถ.ฉลองกรุง, แขวงลาดกระบัง,\n ลาดกระบัง, กรุงเทพมหานคร, 10520'
                                      .replaceAll('\\n', '\n'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          // const Text(
                          //   'หมายเลขพัสดุ',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Expanded(
                          //       child: TextFormField(
                          //           style: TextStyle(fontSize: 14),
                          //           //initialValue: 'ใส่หมายเลขพัสดุ',
                          //           onChanged: (value) {},
                          //           maxLines: 1,
                          //           decoration: const InputDecoration(
                          //             hintText: 'ใส่หมายเลขพัสดุ',

                          //             //alignLabelWithHint: true,
                          //           ),
                          //           keyboardType: TextInputType.number),
                          //     ),
                          //     IconButton(
                          //       onPressed: () {},
                          //       icon: Icon(Icons.done),
                          //       color: primaryColor,
                          //     )
                          //   ],
                          // ),
                          //const Divider(thickness: 0.6, height: 32),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddDisputeScreen(
                                          contract: widget.contract,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('เปิดข้อพิพาท'),
                                  style: TextButton.styleFrom(
                                    primary: primaryColor,
                                    //backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(
                                          color: primaryColor, width: 1),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
          }),
    );
  }
}
