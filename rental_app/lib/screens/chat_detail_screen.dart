import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    Key? key,
    required this.chatWithUserName,
    required this.chatId,
  }) : super(key: key);
  final String chatWithUserName, chatId;
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
      },
    );
    await chats.doc(widget.chatId).update(
      {
        'lastestMessage': _controller.text,
        'lastestMessageSender': currentUserId,
        'lastestMessageCreatedOn': DateTime.now(),
      },
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
                isMe: message['sender'] == currentUserId,
                createdOn: DateFormat('yyyy-MM-dd hh:mm')
                    .format(message['createdOn'].toDate()),
              );
            },
          );
        });
  }

  Widget _buildSendMessageTextField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "พิมพ์ข้อความ...",
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
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
        //backgroundColor: primaryColor[50],
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
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(
      {required String message,
      required bool isMe,
      required String createdOn}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Align(
        alignment: (isMe ? Alignment.topRight : Alignment.topLeft),
        child: Tooltip(
          message: createdOn,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: (isMe ? primaryColor : Colors.grey[200]),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: Text(
              message,
              style: TextStyle(
                  color: (isMe ? Colors.white : Colors.black), fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
