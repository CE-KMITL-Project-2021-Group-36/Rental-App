import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:file_picker/file_picker.dart';

import 'package:rental_app/api/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class UploadEvidenceScreen extends StatefulWidget {
  const UploadEvidenceScreen({Key? key, required this.contract})
      : super(key: key);
  @override
  State<UploadEvidenceScreen> createState() => _UploadEvidenceScreenState();

  final Contract contract;
}

class _UploadEvidenceScreenState extends State<UploadEvidenceScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  File? pickupVideo;
  File? returnVideo;
  bool isUploaded1 = false;
  bool isUploaded2 = false;

  Future selectFile(file) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result == null) return;
    final path = result.files.single.path!;
    if (file == 'pickup') {
      setState(() {
        pickupVideo = File(path);
        isUploaded1 = false;
      });
    } else {
      setState(() {
        returnVideo = File(path);
        isUploaded2 = false;
      });
    }
    // setState(() => file == pickupVideo
    //     ? pickupVideo = File(path)
    //     : returnVideo = File(path));
  }

  Future uploadFile(file) async {
    if (file == null) return;
    final contractId = widget.contract.id;

    if (file == 'pickup') {
      //final fileName = basename(pickupVideo!.path);
      final destination =
          'contract_evidence/$contractId/renter/pickup_video';
      await FirebaseApi.uploadFile(destination, pickupVideo!);
      setState(() {
        isUploaded1 = true;
      });
      // if (task1 == null) return;
      // final snapshot1 = await task1!.whenComplete(() {});
      // final urlDownload = await snapshot1.ref.getDownloadURL();
      // print('Download-Link: $urlDownload');
    } else {
      //final fileName = basename(returnVideo!.path);
      final destination =
          'contract_evidence/$contractId/renter/return_video';
      await FirebaseApi.uploadFile(destination, returnVideo!);
      setState(() {
        isUploaded2 = true;
      });
      // if (task2 == null) return;
      //final snapshot2 = await task2!.whenComplete(() {});
      //final urlDownload = await snapshot2.ref.getDownloadURL();
      //print('Download-Link: $urlDownload');
    }
  }

  @override
  Widget build(BuildContext context) {
    var fileName1 =
        pickupVideo != null ? basename(pickupVideo!.path) : 'กรุณาเลือกไฟล์';
    var fileName2 =
        returnVideo != null ? basename(returnVideo!.path) : 'กรุณาเลือกไฟล์';
    DateTime startDate = widget.contract.startDate.toDate();
    DateTime endDate = widget.contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('สัญญาเช่า'),
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
                                    const Text(
                                      'กรุณาถ่ายและอัปโหลดวิดีโอการเปิดกล่องพัสดุ',
                                      style: TextStyle(
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
                          _buildUploadSection(fileName1, fileName2),
                          //const Divider(thickness: 0.6, height: 32),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(children: const <Widget>[
                            Expanded(
                              child: Divider(color: primaryColor),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'รายละเอียดสัญญา',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: primaryColor),
                            ),
                          ]),
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
                                    currencyFormat(widget.contract.rentalPrice),
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
                                    currencyFormat(widget.contract.deposit),
                                style: const TextStyle(
                                  fontSize: 18,
                                  // color: primaryColor,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
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
                                    currencyFormat(widget.contract.rentalPrice +
                                            widget.contract.deposit),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.6, height: 32),
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

  Widget _buildUploadSection(fileName1, fileName2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เมื่อได้รับสินค้า',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'อัปโหลดวิดีโอหลักฐานตอนเปิดกล่องพัสดุ และตรวจสอบสินค้าก่อนใช้งาน',
          style: TextStyle(
              //fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 100,
          height: 100,
          child: InkWell(
            splashColor: primaryColor,
            onTap: () {
              selectFile('pickup');
            },
            child: Ink(
              decoration: BoxDecoration(
                color: primaryColor[50],
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: const Icon(Icons.videocam, color: primaryColor, size: 48),
            ),
          ),
        ),
        Text(fileName1, style: const TextStyle(height: 2)),
        pickupVideo != null
            ? Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: isUploaded1
                        ? Row(
                            children: const [
                              Icon(Icons.done, color: primaryColor, size: 20),
                              Text(
                                'อัปโหลดแล้ว',
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              uploadFile('pickup');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'อัปโหลดวิดีโอ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 4),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
        const Divider(thickness: 0.6, height: 32),
        const Text(
          'เมื่อส่งคืนสินค้า',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'อัปโหลดวิดีโอหลักฐานในการส่งสินค้า และตรวจสอบสินค้าก่อนส่งคืน',
          style: TextStyle(
              //fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 100,
          height: 100,
          child: InkWell(
            splashColor: primaryColor,
            onTap: () {
              selectFile('return');
            },
            child: Ink(
              decoration: BoxDecoration(
                color: primaryColor[50],
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: const Icon(Icons.videocam, color: primaryColor, size: 48),
            ),
          ),
        ),
        Text(fileName2, style: const TextStyle(height: 2)),
        returnVideo != null
            ? Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: isUploaded2
                        ? Row(
                            children: const [
                              Icon(Icons.done, color: primaryColor, size: 20),
                              Text(
                                'อัปโหลดแล้ว',
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              uploadFile('return');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'อัปโหลดวิดีโอ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 4),
                ],
              )
            : const SizedBox.shrink(),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                'ภูริวัจน์ วิจิตธัญโรจน์'.replaceAll('\\n', '\n'),
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
      ],
    );
  }
}
