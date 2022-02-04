import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();

  static const String routeName = '/chat_detail';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ChatDetailScreen(),
    );
  }
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "ร้านเดินทางไปได้ยังไงครับ?", messageType: "sender"),
    ChatMessage(
        messageContent: "ลง bts ห้าแยกลาดพร้าว อยู่ตรงข้ามเซนทรัลครับ",
        messageType: "receiver"),
    ChatMessage(messageContent: "โอเคครับ👍", messageType: "sender"),
    ChatMessage(
        messageContent: "ถ้าหาร้านไม่เจอ เดี๋ยวทักมาอีกรอบนะครับ",
        messageType: "sender"),
    ChatMessage(messageContent: "ได้ครับ😀", messageType: "receiver"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('RentKlong'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType == "receiver"
                          ? Colors.grey.shade200
                          : primaryColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(
                          color: (messages[index].messageType == "receiver"
                              ? Colors.black
                              : Colors.white),
                          fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                    ),
                    color: primaryColor,
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: TextField(
                        decoration: InputDecoration(
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}
