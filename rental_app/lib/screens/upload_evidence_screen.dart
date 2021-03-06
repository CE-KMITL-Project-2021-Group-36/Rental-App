import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rental_app/api/firebase_api.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchUrl(url) async {
    url = Uri.parse(url);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  Future selectFile(file) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
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
              'renterStatus': '???????????????????????????????????????',
            })
          : await contractRef.update({
              'ownerDeliveryVideo': file1Url,
              'ownerStatus': '???????????????????????????????????????',
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
    final bool isActive = widget.contract.renterStatus == '???????????????????????????????????????' ||
        widget.contract.renterStatus == '???????????????????????????????????????' ||
        widget.contract.ownerStatus == '???????????????????????????????????????' ||
        widget.contract.ownerStatus == '???????????????????????????????????????';

    return Scaffold(
      appBar: AppBar(
        title: const Text('???????????????????????????'),
        actions: <Widget>[
          TextButton(
            child: Row(
              children: [
                isRenter
                    ? const Text(
                        '????????????????????????????????????????????????',
                        style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.normal),
                      )
                    : const Text(
                        '???????????????????????????????????????',
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
                                    '???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????\n??????????????????????????????????????????????????????????????????????????????',
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
                    isRenter
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Text(
                                    '??????????????????????????????????????????????????????????????????????????????',
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
                              const Text(
                                '?????????????????????????????????????????????',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.contract.ownerDeliveryVideo == ''
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '- ????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () {
                                          final url = widget
                                              .contract.ownerDeliveryVideo;
                                          _launchUrl(url);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.play_arrow_rounded),
                                            Text(
                                              '??????????????????????????????',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
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
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                '??????????????????????????????????????????????????????????????????????????????',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.contract.ownerPickupVideo == ''
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '- ????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () {
                                          final url =
                                              widget.contract.ownerPickupVideo;
                                          _launchUrl(url);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.play_arrow_rounded),
                                            Text(
                                              '??????????????????????????????',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
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
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Text(
                                    '?????????????????????????????????????????????????????????????????????',
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
                              const Text(
                                '?????????????????????????????????????????????????????????????????????',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.contract.renterReturnVideo == ''
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '- ????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () {
                                          final url =
                                              widget.contract.renterPickupVideo;
                                          _launchUrl(url);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.play_arrow_rounded),
                                            Text(
                                              '??????????????????????????????',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
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
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                '?????????????????????????????????????????????????????????????????????',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.contract.renterPickupVideo == ''
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '- ????????????????????????????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () {
                                          final url =
                                              widget.contract.renterReturnVideo;
                                          _launchUrl(url);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.play_arrow_rounded),
                                            Text(
                                              '??????????????????????????????',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
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
                            ],
                          ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text(
                          '?????????????????????????????????????????????',
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product',
                                    arguments: Product.fromSnapshot(product!),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox.fromSize(
                                    child: Image.network(
                                      product!['imageUrl'][0],
                                      fit: BoxFit.cover,
                                      height: 100.0,
                                      width: 100.0,
                                    ),
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
                                      '?????????????????????????????? $formattedStartDate ????????? $formattedEndDate',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      '??????????????????????????????????????????????????????',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '???' +
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
                            '????????????????????????????????????????????????',
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
                      '??????????????????????????????????????????????????????',
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
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 100),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: NetworkImage(widget
                                            .contract.renterAttachments[index]),
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              );
                            })
                        : const Text(
                            '??????????????????????????????????????????',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                    const SizedBox(height: 32),
                    widget.contract.renterAddressName == ''
                        ? const SizedBox()
                        : Container(
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
                                      '??????????????????????????????????????????',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(widget.contract.renterAddressName),
                                Text(widget.contract.renterAddressPhone),
                                Text(widget.contract.renterAddress),
                              ],
                            ),
                          ),
                    const SizedBox(height: 16),
                    const Text(
                      '??????????????????????????????????????????',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '?????????????????????',
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '???' + currencyFormat(widget.contract.rentalPrice),
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
                          '????????????????????????',
                        ),
                        Text(
                          '???' + currencyFormat(widget.contract.deposit),
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
                          '???????????????????????????????????????',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          '???' +
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
                                    '?????????????????????????????????',
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
                                      child: const Text('????????????????????????????????????'),
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
    //???????????????????????? -> ???????????????????????? = ???????????????????????????????????????
    //??????????????????????????? -> ?????????????????????????????????????????????
    if (!isRenter && widget.contract.ownerStatus == '???????????????????????????????????????') {
      return _buildConfirmButton(context, '????????????????????????????????????????????????????????????????????????', 1);
    }
    //??????????????????????????? -> ????????????????????????
    if (isRenter && widget.contract.renterStatus == '???????????????????????????????????????') {
      return _buildConfirmButton(context, '????????????????????????????????????????????????????????????????????????', 2);
    }
    //??????????????????????????? -> ??????????????????????????????????????????????????????
    if (isRenter && widget.contract.renterStatus == '???????????????????????????????????????') {
      return _buildConfirmButton(context, '?????????????????????????????????????????????????????????????????????????????????', 3);
    }
    //?????????????????????
    if (!isRenter && widget.contract.ownerStatus == '???????????????????????????????????????') {
      return _buildConfirmButton(context, '?????????????????????????????????????????????????????????????????????????????????', 4);
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(condition) async {
    final contractId = widget.contract.id;
    final contractRef =
        FirebaseFirestore.instance.collection("contracts").doc(contractId);

    if (condition == 1) {
      await contractRef.update({
        'ownerStatus': '???????????????????????????????????????',
      });
      sendNotification(
        widget.contract.renterId,
        '????????????????????????????????????????????????',
        '??????????????????: $productName',
        'renter',
      );
    }
    if (condition == 2) {
      await contractRef.update({
        'renterStatus': '???????????????????????????????????????',
      });
      sendNotification(
        widget.contract.ownerId,
        '?????????????????????????????????????????????????????????????????????',
        '??????????????????: $productName',
        'owner',
      );
    }
    if (condition == 3) {
      await contractRef.update({
        'renterStatus': '????????????????????????????????????',
      });
      sendNotification(
        widget.contract.ownerId,
        '?????????????????????????????????????????????????????????????????????',
        '??????????????????: $productName',
        'owner',
      );
    }
    if (condition == 4) {
      await contractRef.update({
        'renterStatus': '??????????????????',
        'ownerStatus': '??????????????????',
      });
      final String timestamp =
          (DateTime.now().millisecondsSinceEpoch / 1000).ceil().toString();
      //Refund Deposit to Renter
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contract.renterId)
          .collection('wallet_transactions')
          .doc(timestamp)
          .set({
        'amount': widget.contract.deposit,
        'timestamp': timestamp,
        'type': '?????????????????????????????????????????????',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contract.renterId)
          .update({
        'wallet.balance': FieldValue.increment(widget.contract.deposit)
      });
      //Transfer rental fee to Owner
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contract.ownerId)
          .collection('wallet_transactions')
          .doc(timestamp)
          .set({
        'amount': widget.contract.rentalPrice,
        'timestamp': timestamp,
        'type': '???????????????????????????????????????',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contract.ownerId)
          .update({
        'wallet.balance': FieldValue.increment(widget.contract.rentalPrice)
      });

      sendNotification(
        widget.contract.renterId,
        '???????????????????????????????????????',
        '??????????????????: $productName',
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
              '????????????????????????????????????????????????????????????',
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
                '?????????????????????????????????????????????????????????????????????',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                '????????????????????????????????????????????????????????????',
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
                              '?????????????????????????????????????????????',
                              style: TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                              ),
                            )
                          : const Text(
                              '?????????????????????????????????',
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
                    ? Column(
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.done, color: primaryColor, size: 20),
                              Text(
                                '?????????????????????????????????',
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              final url = !isRenter
                                  ? widget.contract.ownerDeliveryVideo
                                  : widget.contract.renterPickupVideo;
                              _launchUrl(url);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.play_arrow_rounded),
                                Text(
                                  '??????????????????????????????',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                                    '???????????????????????????????????????',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            isRenter
                ? const Text(
                    '?????????????????????????????????????????????????????????????????????',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(
                    '?????????????????????????????????????????????????????????????????????',
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
                                  '?????????????????????????????????????????????',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primaryColor,
                                  ),
                                )
                              : const Text(
                                  '?????????????????????????????????',
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
                        ? Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.done,
                                      color: primaryColor, size: 20),
                                  Text(
                                    '?????????????????????????????????',
                                    style: TextStyle(
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  final url = !isRenter
                                      ? widget.contract.ownerPickupVideo
                                      : widget.contract.renterReturnVideo;
                                  _launchUrl(url);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.play_arrow_rounded),
                                    Text(
                                      '??????????????????????????????',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        '???????????????????????????????????????',
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
            const SizedBox(height: 16),
            isRenter
                ? _buildOwnerAddress(widget.contract.ownerId)
                : const SizedBox.shrink(),
          ],
        )
      ],
    );
  }
}

Widget _buildOwnerAddress(ownerId) {
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
    child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(ownerId)
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
          final user = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '???????????????????????????????????????????????????',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                user!['shop']['userName'],
              ),
              Text(
                user['shop']['phone'],
              ),
              Text(
                user['shop']['address'],
              ),
            ],
          );
        }),
  );
}
