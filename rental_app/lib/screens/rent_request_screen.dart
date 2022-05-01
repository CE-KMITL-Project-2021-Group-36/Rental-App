import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';

class RentRequestScreen extends StatefulWidget {
  const RentRequestScreen(
      {Key? key,
      required this.product,
      required this.dateRange,
      required this.price})
      : super(key: key);
  final Product product;
  final DateTimeRange dateRange;
  final double price;

  @override
  State<RentRequestScreen> createState() => _RentRequestScreenState();
}

class _RentRequestScreenState extends State<RentRequestScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference contractRef =
      FirebaseFirestore.instance.collection('contracts');

  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  final List<File> _image = [];
  final List _imageUrl = [];
  final picker = ImagePicker();
  String address = '', addressName = '', addressPhone = '';
  ValueNotifier<bool> pickedAddress = ValueNotifier(false);

  int selectedRadioTile = 0;
  String selectedDeliveryType = '';

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Widget _buildRadioListTiles() {
    if (widget.product.deliveryType == 'รับสินค้าที่ร้าน/จัดส่งสินค้า') {
      return Column(
        children: [
          RadioListTile(
            value: 1,
            groupValue: selectedRadioTile,
            title: const Text(
              'รับสินค้าที่ร้าน',
              style: TextStyle(fontSize: 14),
            ),
            onChanged: (val) {
              setSelectedRadioTile(val as int);
            },
            dense: true,
            contentPadding: const EdgeInsets.all(0),
          ),
          RadioListTile(
            value: 2,
            groupValue: selectedRadioTile,
            title: const Text(
              'จัดส่งสินค้า',
              style: TextStyle(fontSize: 14),
            ),
            onChanged: (val) {
              setSelectedRadioTile(val as int);
            },
            dense: true,
            contentPadding: const EdgeInsets.all(0),
          ),
        ],
      );
    } else if (widget.product.deliveryType == 'รับสินค้าที่ร้าน') {
      return RadioListTile(
        value: 1,
        groupValue: selectedRadioTile,
        title: const Text(
          'รับสินค้าที่ร้าน',
          style: TextStyle(fontSize: 14),
        ),
        onChanged: (val) {
          setSelectedRadioTile(val as int);
        },
        dense: true,
        contentPadding: const EdgeInsets.all(0),
      );
    } else if (widget.product.deliveryType == 'จัดส่งสินค้า') {
      return RadioListTile(
        value: 2,
        groupValue: selectedRadioTile,
        title: const Text(
          'จัดส่งสินค้า',
          style: TextStyle(fontSize: 14),
        ),
        onChanged: (val) {
          setSelectedRadioTile(val as int);
        },
        dense: true,
        contentPadding: const EdgeInsets.all(0),
      );
    }
    return const Text(
      'โปรดติดต่อเจ้าของสินค้า',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }

  chooseImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('กล้องถ่ายรูป'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('เลือกจากคลัง'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.gallery);
              },
            )
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      debugPrint(response.file.toString());
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = storage.ref().child(
          'contract_images/${FirebaseAuth.instance.currentUser?.uid}/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imageUrl.add(value);
          i++;
        });
      });
    }
  }

  createRentRequest() async {
    selectedDeliveryType =
        selectedRadioTile == 1 ? 'รับสินค้าที่ร้าน' : 'จัดส่งสินค้า';
    await uploadFile();
    await contractRef.add({
      'productId': widget.product.id,
      'renterId': FirebaseAuth.instance.currentUser?.uid,
      'ownerId': widget.product.owner,
      'rentalPrice': widget.price,
      'deposit': 0,
      'startDate': widget.dateRange.start,
      'endDate': widget.dateRange.end,
      'renterStatus': 'รอการอนุมัติ',
      'ownerStatus': 'รอการอนุมัติ',
      'renterAttachments': FieldValue.arrayUnion(_imageUrl),
      'renterPickupVideo': '',
      'renterReturnVideo': '',
      'ownerDeliveryVideo': '',
      'ownerPickupVideo': '',
      'renterAddressName': addressName,
      'renterAddressPhone': addressPhone,
      'renterAddress': address,
      'deliveryType': selectedDeliveryType,
    });

    final receiver = widget.product.owner;
    String title = 'มีคำขอเช่าใหม่';
    String text = 'รายการ: ${widget.product.name}';
    String type = 'owner';
    sendNotification(receiver, title, text, type);
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.dateRange.start;
    DateTime endDate = widget.dateRange.end;
    double price = widget.price;
    String formattedStartDate = DateFormat('dd/MM/yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd/MM/yyyy').format(endDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำขอเช่า'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              widget.product.imageUrl[0],
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
                                widget.product.name,
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
                                    '฿' + currencyFormat(price),
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
                      widget.product.deposit.replaceAll('\\n', '\n'),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'เอกสารแนบเพิ่มเติม',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _image.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return index == 0
                      ? InkWell(
                          splashColor: primaryColor,
                          onTap: (() => !uploading ? chooseImage() : null),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: primaryColor[50],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: const Icon(Icons.add_rounded,
                                color: primaryColor, size: 60),
                          ),
                        )
                      : Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(_image[index - 1]),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: errorColor,
                              ),
                              tooltip: 'ลบรูปนี้',
                              onPressed: () {
                                setState(() {
                                  _image.removeAt(index - 1);
                                });
                              },
                            ),
                          ],
                        );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 32),
                  const Text(
                    'การจัดส่ง',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRadioListTiles()
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'ที่อยู่ของคุณ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Ink(
                decoration: BoxDecoration(
                  color: pickedAddress.value
                      ? primaryLightColor
                      : primaryColor[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () async {
                    final result =
                        await Navigator.pushNamed(context, '/edit_address')
                            as List<String>;
                    debugPrint(result[0].toString());
                    debugPrint(result[1].toString());
                    debugPrint(result[2].toString());
                    setState(() {
                      addressName = result[0];
                      addressPhone = result[1];
                      address = result[2];
                      pickedAddress.value = true;
                    });
                  },
                  contentPadding: const EdgeInsets.all(15),
                  trailing: pickedAddress.value
                      ? const Icon(
                          Icons.edit,
                          color: primaryColor,
                        )
                      : null,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Wrap(
                      children: [
                        pickedAddress.value
                            ? Row(
                                children: [
                                  Text(
                                    addressName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '  ' + addressPhone,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_rounded,
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'เลือกที่อยู่',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  subtitle: pickedAddress.value
                      ? Text(
                          address,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 64),
              ValueListenableBuilder(
                  valueListenable: pickedAddress,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: pickedAddress.value
                                ? () async {
                                    await createRentRequest();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      '/contract_management',
                                      arguments: ['renter', '0'],
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('ส่งคำขอเช่าแล้ว'),
                                    ));
                                  }
                                : null,
                            child: const Text('ส่งคำขอเช่า'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: pickedAddress.value
                                  ? primaryColor
                                  : primaryLightColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
