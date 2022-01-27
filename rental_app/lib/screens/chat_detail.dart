import 'package:flutter/material.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({Key? key}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "ร้านเดินทางไปได้ยังไงครับ?", messageType: "sender"),
    ChatMessage(messageContent: "ลง bts ห้าแยกลาดพร้าว อยู่ตรงข้ามเซนทรัลครับ", messageType: "receiver"),
    ChatMessage(
        messageContent: "โอเคครับ👍",
        messageType: "sender"),
    ChatMessage(messageContent: "ถ้าหาร้านไม่เจอ เดี๋ยวทักมาอีกรอบนะครับ", messageType: "sender"),
    ChatMessage(
        messageContent: "ได้ครับ😀", messageType: "receiver"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/shop_profile.png'),
                  maxRadius: 16,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "RentKlong",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
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
                padding:
                    const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType == "receiver"
                          ? Colors.grey.shade200
                          : Colors.indigo),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(color: (messages[index].messageType == "receiver"
                          ? Colors.black
                          : Colors.white),fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              //padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
              height: 56,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                    ),
                    padding: const EdgeInsets.all(0),
                    iconSize: 18,
                    color: Colors.indigo,
                    splashColor: Colors.indigo,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "พิมพ์ข้อความ...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                    ),
                    iconSize: 18,
                    color: Colors.indigo,
                    splashColor: Colors.indigo,
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

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}
