import 'package:flutter/material.dart';
import 'package:rental_app/chat_detail.dart';
import 'package:rental_app/config/palette.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();

    static const String routeName = '/chat';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ChatScreen(),
    );
  }
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'ข้อความ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.support_agent,
              ),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: primaryColor,
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
                    _buildChatRoom('assets/images/shop_profile.png','RentKlong','ได้ครับ😀','วันนี้\n9:10 PM'),
                    _buildChatRoom('assets/images/manee_profile.png','มานี มีนา','ขอลดหน่อยได้มั้ย','เมื่อวาน\n8:10 AM'),
                    _buildChatRoom('assets/images/tony_profile.png','โทนี่ พีรศักดิ์','ขอดูสินค้าเพิ่มเติมหน่อยครับ','30 พ.ย.\n11:12 PM'),
                  ]),
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatRoom('assets/images/shop_profile.png','RentKlong','ได้ครับ😀','วันนี้\n9:10 PM'),
                  ]),
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatRoom('assets/images/manee_profile.png','มานี มีนา','ขอลดหน่อยได้มั้ย','เมื่อวาน\n8:10 AM'),
                    _buildChatRoom('assets/images/tony_profile.png','โทนี่ พีรศักดิ์','ขอดูสินค้าเพิ่มเติมหน่อยครับ','30 พ.ย.\n11:12 PM'),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatRoom(profileImage, name, lastMessage, timestamp) {
    return TextButton(
      onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatDetail()),
            );},
      style: ButtonStyle(
        //side: MaterialStateProperty.all(BorderSide(width: 2, color: Colors.red)),
        //foregroundColor: MaterialStateProperty.all(Colors.black),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage(profileImage),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(lastMessage,
                  style: const TextStyle(color: Colors.black54, fontSize: 16))
            ],
          ),
        ),
        Text(timestamp,
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400), textAlign: TextAlign.right),
      ]),
    );
  }
}
