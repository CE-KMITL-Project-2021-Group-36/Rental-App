import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/screens/upload_evidence_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    Key? key,
    required this.chatWithUserName,
    required this.chatWithUserId,
    required this.chatId,
  }) : super(key: key);
  final String chatWithUserName, chatWithUserId, chatId;
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final ImagePicker _picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String currentUserName = '';

  _findUserName() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      currentUserName = data?['firstName'] + ' ' + data?['lastName'];
    }
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _findUserName();
  }

  Future pickImage(ImageSource source) async {
    XFile? file = await _picker.pickImage(source: source);
    if (file == null) return;
    File image = File(file.path);
    await uploadImage(image);
  }

  Future uploadImage(image) async {
    if (image == null) return;
    final imageName = basename(image!.path);
    final destination = 'chats/$currentUserId/$imageName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    await ref.putFile(image!);
    final imageUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(
      {
        'createdOn': DateTime.now(),
        'message': imageUrl,
        'sender': currentUserId,
        'type': 'image'
      },
    );
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update(
      {
        'lastestMessage': 'ส่งรูปภาพ',
        'lastestMessageSender': currentUserId,
        'lastestMessageCreatedOn': DateTime.now(),
      },
    );
    sendNotification(
      widget.chatWithUserId,
      currentUserName,
      'ส่งรูปภาพ',
      'chat',
    );
  }

  void sendMessage() async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    await messages.add(
      {
        'createdOn': DateTime.now(),
        'message': _controller.text,
        'sender': currentUserId,
        'type': 'text'
      },
    );
    await chats.doc(widget.chatId).update(
      {
        'lastestMessage': _controller.text,
        'lastestMessageSender': currentUserId,
        'lastestMessageCreatedOn': DateTime.now(),
      },
    );
    sendNotification(
      widget.chatWithUserId,
      currentUserName,
      _controller.text,
      'chat',
    );
    _controller.clear();
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('มีบางอย่างผิดพลาด');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final messages = snapshot.data;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          shrinkWrap: true,
          itemCount: messages!.docs.length,
          itemBuilder: (context, index) {
            final message = messages.docs[index];
            return _buildMessage(
              message: message['message'],
              type: message['type'],
              isMe: message['sender'] == currentUserId,
              createdOn: DateFormat('yyyy-MM-dd hh:mm')
                  .format(message['createdOn'].toDate()),
            );
          },
        );
      },
    );
  }

  Widget _buildSendMessageTextField() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.photo_camera,
          ),
          color: primaryColor,
          onPressed: () {
            pickImage(ImageSource.camera);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.photo,
          ),
          color: primaryColor,
          onPressed: () {
            pickImage(ImageSource.gallery);
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
                hintText: "พิมพ์ข้อความ...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 223, 218, 255), width: 2),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
          ),
          color: primaryColor,
          onPressed: () {
            sendMessage();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.chatWithUserName),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: _buildMessageList(),
              ),
            ),
            _buildSendMessageTextField(),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessage({
    required String message,
    required bool isMe,
    required String createdOn,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Align(
        alignment: (isMe ? Alignment.topRight : Alignment.topLeft),
        child: Tooltip(
          message: createdOn,
          child: _buildContent(type, message, isMe),
        ),
      ),
    );
  }

  _buildContent(type, message, isMe) {
    switch (type) {
      case 'text':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: (isMe ? primaryColor : Colors.grey[200]),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: Text(
            message,
            style: TextStyle(
              color: (isMe ? Colors.white : Colors.black),
              fontSize: 16,
            ),
          ),
        );
      case 'image':
        return Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            message,
          ),
        );
      case 'contract':
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("contracts")
                .doc(message)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('มีบางอย่างผิดพลาด');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final contractData = snapshot.data;
              final startDate = DateFormat('dd-MM-yyyy')
                  .format(contractData!['startDate'].toDate());
              final endDate = DateFormat('dd-MM-yyyy')
                  .format(contractData['endDate'].toDate());
              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .doc(contractData['productId'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('มีบางอย่างผิดพลาด');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.data;
                    return Material(
                      color: surfaceColor,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadEvidenceScreen(
                                contract: Contract.fromSnapshot(contractData),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: outlineColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'สัญญาเช่าสินค้า',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox.fromSize(
                                        child: Image.network(
                                      data!['imageUrl'],
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                    )),
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
                                          data['name'],
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
                                          'เช่าวันที่ $startDate ถึง $endDate',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            });
      case 'product':
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("products")
              .doc(message)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('มีบางอย่างผิดพลาด');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final productData = snapshot.data;

            String displayPrice() {
              if (productData!['pricePerDay'] > 0.0) {
                return '฿' +
                    currencyFormat(productData['pricePerDay'].toDouble()) +
                    '/วัน';
              } else if (productData['pricePerWeek'] > 0.0) {
                return '฿' +
                    currencyFormat(productData['pricePerWeek'].toDouble()) +
                    '/สัปดาห์';
              } else {
                return '฿' +
                    currencyFormat(productData['pricePerMonth'].toDouble()) +
                    '/เดือน';
              }
            }

            return Material(
              color: surfaceColor,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        product: Product.fromSnapshot(productData!),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    //color: surfaceColor,
                    border: Border.all(
                      color: outlineColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'สินค้า',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox.fromSize(
                              child: Image.network(
                                productData!['imageUrl'],
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
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
                                  productData['name'],
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
                                  displayPrice(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      default:
        return const Text('บางอย่างผิดพลาด');
    }
  }
}
