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
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  File? file1;
  File? file2;
  String file1Url = '';
  String file2Url = '';
  bool isUploaded1 = false;
  bool isUploaded2 = false;
  String productName = '';

  Future selectFile(file) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result == null) return;
    final path = result.files.single.path!;
    if (file == 'file1') {
      setState(() {
        file1 = File(path);
        isUploaded1 = false;
      });
    } else {
      setState(() {
        file2 = File(path);
        isUploaded2 = false;
      });
    }
  }

  Future uploadFile(file) async {
    if (file == null) return;
    final contractId = widget.contract.id;
    final contractRef =
        FirebaseFirestore.instance.collection("contracts").doc(contractId);
    final bool isRenter = currentUserId == widget.contract.renterId;

    if (file == 'file1') {
      //final fileName = basename(pickupVideo!.path);
      final destination = isRenter
          ? 'contract_evidence/$contractId/renter/pickup_video'
          : 'contract_evidence/$contractId/owner/delivery_video';
      final ref = FirebaseStorage.instance.ref(destination);

      await FirebaseApi.uploadFile(destination, file1!);
      await ref
          .getDownloadURL()
          .then((value) => setState(() => file1Url = value));
      isRenter
          ? await contractRef.update({
              'renterPickupVideo': file1Url,
              'renterStatus': 'ที่ต้องส่งคืน',
            })
          : await contractRef.update({
              'ownerDeliveryVideo': file1Url,
              'ownerStatus': 'ที่ต้องได้คืน',
            });
      setState(() {
        isUploaded1 = true;
      });
    } else {
      final destination = isRenter
          ? 'contract_evidence/$contractId/renter/return_video'
          : 'contract_evidence/$contractId/owner/pickup_video';
      final ref = FirebaseStorage.instance.ref(destination);

      await FirebaseApi.uploadFile(destination, file2!);
      await ref
          .getDownloadURL()
          .then((value) => setState(() => file2Url = value));
      isRenter
          ? await contractRef.update({
              'renterReturnVideo': file2Url,
            })
          : await contractRef.update({
              'ownerPickupVideo': file2Url,
            });
      setState(() {
        isUploaded2 = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bool isRenter = currentUserId == widget.contract.renterId;
    if (isRenter) {
      if (widget.contract.renterPickupVideo != '') {
        isUploaded1 = true;
      }
      if (widget.contract.renterReturnVideo != '') {
        isUploaded2 = true;
      }
    } else {
      if (widget.contract.ownerDeliveryVideo != '') {
        isUploaded1 = true;
      }
      if (widget.contract.ownerPickupVideo != '') {
        isUploaded2 = true;
      }
    }
    _findProductName();
  }

  _findProductName() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.contract.productId)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      productName = data?['name'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var fileName1 = file1 != null ? basename(file1!.path) : '';
    var fileName2 = file2 != null ? basename(file2!.path) : '';
    DateTime startDate = widget.contract.startDate.toDate();
    DateTime endDate = widget.contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    final bool isRenter = currentUserId == widget.contract.renterId;
    final bool isActive = widget.contract.renterStatus == 'ที่ต้องได้รับ' ||
        widget.contract.renterStatus == 'ที่ต้องส่งคืน' ||
        widget.contract.ownerStatus == 'ที่ต้องจัดส่ง' ||
        widget.contract.ownerStatus == 'ที่ต้องได้คืน';

    return Scaffold(
      appBar: AppBar(
        title: const Text('สัญญาเช่า'),
        actions: <Widget>[
          TextButton(
            child: Row(
              children: [
                isRenter
                    ? const Text(
                        'ติดต่อผู้ให้เช่า',
                        style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.normal),
                      )
                    : const Text(
                        'ติดต่อผู้เช่า',
                        style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.normal),
                      )
              ],
            ),
            onPressed: () {
              isRenter
                  ? enterChatRoom(
                      context: context,
                      currentUserId: currentUserId,
                      chatWithUser: widget.contract.ownerId,
                      message: widget.contract.id,
                      messageType: 'contract')
                  : enterChatRoom(
                      context: context,
                      currentUserId: currentUserId,
                      chatWithUser: widget.contract.renterId,
                      message: widget.contract.id,
                      messageType: 'contract');
            },
          ),
        ],
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isActive
                        ? Container(
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
                              children: const [
                                Icon(Icons.videocam, color: Colors.white),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    'กรุณาถ่ายและอัปโหลดวิดีโอเพื่อเป็นหลักฐาน\nในการรับและการจัดส่งสินค้า',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    isActive
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 32,
                              ),
                              _buildUploadSection(fileName1, fileName2),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    Row(children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text(
                          'รายละเอียดสัญญา',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey),
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
                                    product!['imageUrl'],
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
                                    const Text(
                                      'ค่าเช่าไม่รวมมัดจำ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '฿' +
                                              currencyFormat(
                                                  widget.contract.rentalPrice),
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
                    widget.contract.renterAttachments.isNotEmpty
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.contract.renterAttachments.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Ink.image(
                                    image: NetworkImage(widget
                                        .contract.renterAttachments[index]),
                                    fit: BoxFit.cover,
                                    child: InkWell(
                                      onTap: () {
                                        //Go to ImageView
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              );
                            })
                        : const Text(
                            'ไม่มีเอกสารแนบ',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                    const SizedBox(height: 32),
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
                          '฿' + currencyFormat(widget.contract.rentalPrice),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ค่ามัดจำ',
                        ),
                        Text(
                          '฿' + currencyFormat(widget.contract.deposit),
                          style: const TextStyle(
                            fontSize: 18,
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
                    const SizedBox(
                      height: 32,
                    ),
                    isActive
                        ? Column(
                            children: [
                              Row(children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Text(
                                    'จัดการสัญญา',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey),
                                ),
                              ]),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddDisputeScreen(
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                              _confirmation(context, isRenter),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _confirmation(context, bool isRenter) {
    //ชำระเงิน -> รอจัดส่ง = ที่ต้องได้รับ
    //ส่งสินค้า -> รอผู้เช่ายืนยัน
    if (!isRenter && widget.contract.ownerStatus == 'ที่ต้องจัดส่ง') {
      return _buildConfirmButton(context, 'ยืนยันการส่งสินค้าสำเร็จ', 1);
    }
    //รับสินค้า -> รอส่งคืน
    if (isRenter && widget.contract.renterStatus == 'ที่ต้องได้รับ') {
      return _buildConfirmButton(context, 'ยืนยันการรับสินค้าสำเร็จ', 2);
    }
    //คืนสินค้า -> รอผู้ให้เช่ายืนยัน
    if (isRenter && widget.contract.renterStatus == 'ที่ต้องส่งคืน') {
      return _buildConfirmButton(context, 'ยืนยันการส่งคืนสินค้าสำเร็จ', 3);
    }
    //จบสัญญา
    if (!isRenter && widget.contract.ownerStatus == 'ที่ต้องได้คืน') {
      return _buildConfirmButton(context, 'ยืนยันการรับสินค้าคืนสำเร็จ', 4);
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(condition) async {
    final contractId = widget.contract.id;
    final contractRef =
        FirebaseFirestore.instance.collection("contracts").doc(contractId);

    if (condition == 1) {
      await contractRef.update({
        'ownerStatus': 'ที่ต้องได้คืน',
      });
      sendNotification(
        widget.contract.renterId,
        'สินค้าจัดส่งแล้ว',
        'รายการ: $productName',
        'renter',
      );
    }
    if (condition == 2) {
      await contractRef.update({
        'renterStatus': 'ที่ต้องส่งคืน',
      });
      sendNotification(
        widget.contract.ownerId,
        'ผู้เช่าได้รับสินค้าแล้ว',
        'รายการ: $productName',
        'owner',
      );
    }
    if (condition == 3) {
      await contractRef.update({
        'renterStatus': 'รอการจบสัญญา',
      });
      sendNotification(
        widget.contract.ownerId,
        'ผู้เช่าจัดส่งสินค้าแล้ว',
        'รายการ: $productName',
        'owner',
      );
    }
    if (condition == 4) {
      await contractRef.update({
        'renterStatus': 'สำเร็จ',
        'ownerStatus': 'สำเร็จ',
      });
      sendNotification(
        widget.contract.renterId,
        'การเช่าสำเร็จ',
        'รายการ: $productName',
        'owner',
      );
    }
  }

  Widget _buildConfirmButton(context, String text, condition) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              _updateStatus(condition);
              Navigator.pop(context);
            },
            child: Text(text),
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
    );
  }

  Widget _buildUploadSection(fileName1, fileName2) {
    bool isRenter = currentUserId == widget.contract.renterId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              'อัปโหลดวิดีโอหลักฐาน',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey),
          ),
        ]),
        const SizedBox(
          height: 16,
        ),
        isRenter
            ? const Text(
                'วิดีโอเมื่อได้รับสินค้า',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                'วิดีโอเมื่อส่งสินค้า',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: InkWell(
                splashColor: primaryColor,
                onTap: () {
                  selectFile('file1');
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: primaryColor[50],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.videocam,
                        color: primaryColor,
                        size: 48,
                      ),
                      isUploaded1
                          ? const Text(
                              'เลือกวิดีโอใหม่',
                              style: TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                              ),
                            )
                          : const Text(
                              'เลือกวิดีโอ',
                              style: TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isUploaded1
                    ? const SizedBox.shrink()
                    : SizedBox(
                        width: 160,
                        child: Text(
                          '$fileName1',
                          style: const TextStyle(height: 2),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                isUploaded1
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
                    : const SizedBox.shrink(),
                file1 == null || isUploaded1
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: TextButton(
                              onPressed: () {
                                uploadFile('file1');
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
              ],
            ),
          ],
        ),
        widget.contract.renterStatus == 'ที่ต้องส่งคืน' ||
                widget.contract.ownerStatus == 'ที่ต้องได้คืน'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  isRenter
                      ? const Text(
                          'วิดีโอเมื่อส่งคืนสินค้า',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          'วิดีโอเมื่อได้รับสินค้า',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: InkWell(
                          splashColor: primaryColor,
                          onTap: () {
                            selectFile('file2');
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              color: primaryColor[50],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.videocam,
                                  color: primaryColor,
                                  size: 48,
                                ),
                                isUploaded2
                                    ? const Text(
                                        'เลือกวิดีโอใหม่',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: primaryColor,
                                        ),
                                      )
                                    : const Text(
                                        'เลือกวิดีโอ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: primaryColor,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isUploaded2
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  width: 160,
                                  child: Text(
                                    '$fileName2',
                                    style: const TextStyle(height: 2),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                          isUploaded2
                              ? Row(
                                  children: const [
                                    Icon(Icons.done,
                                        color: primaryColor, size: 20),
                                    Text(
                                      'อัปโหลดแล้ว',
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          file2 == null || isUploaded2
                              ? const SizedBox.shrink()
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        onPressed: () {
                                          uploadFile('file2');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'อัปโหลดวิดีโอ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  isRenter ? _buildAddress() : const SizedBox.shrink(),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

Widget _buildAddress() {
  return Container(
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
              'ที่อยู่',
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
  );
}
