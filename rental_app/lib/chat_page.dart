import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo,
          centerTitle: true,
          title: const Text(
            'ข้อความ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          //shadowColor: Colors.transparent,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.support_agent,
                color: Colors.indigo,
              ),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.indigo,
            indicatorColor: Colors.indigo,
            tabs: [
              Tab(text: 'ทั้งหมด'),
              Tab(
                text: 'สำหรับผู้เช่า',
              ),
              Tab(
                text: 'สำหรับร้านเช่า',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatRoom('assets/images/shop_profile.png','RentKlong','ได้ครับ😀','Today\n9:10 PM'),
                    _buildChatRoom('assets/images/manee_profile.png','มานี มีนา','ขอลดหน่อยได้มั้ย','Yesterday\n8:10 AM'),
                    _buildChatRoom('assets/images/tony_profile.png','โทนี่ พีรศักดิ์','ขอดูสินค้าเพิ่มเติมหน่อยครับ','6/11/2021\n11:12 PM'),
                  ]),
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatRoom('assets/images/shop_profile.png','RentKlong','ได้ครับ😀','Today\n9:10 PM'),
                  ]),
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatRoom('assets/images/manee_profile.png','มานี มีนา','ขอลดหน่อยได้มั้ย','Yesterday\n8:10 AM'),
                    _buildChatRoom('assets/images/tony_profile.png','โทนี่ พีรศักดิ์','ขอดูสินค้าเพิ่มเติมหน่อยครับ','6/11/2021\n11:12 PM'),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatRoom(profileImage, name, lastMessage, timestamp) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        //side: MaterialStateProperty.all(BorderSide(width: 2, color: Colors.red)),
        //foregroundColor: MaterialStateProperty.all(Colors.black),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage(profileImage),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Text(lastMessage,
                  style: TextStyle(color: Colors.black54, fontSize: 16))
            ],
          ),
        ),
        Text(timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400), textAlign: TextAlign.right),
      ]),
    );
  }
}
