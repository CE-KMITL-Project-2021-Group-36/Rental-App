import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
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
  bool isSearching = false;
  TextEditingController searchUserEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
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
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatRoom('assets/images/shop_profile.png',
                        'RentKlong', 'ได้ครับ😀', 'วันนี้\n9:10 PM'),
                    _buildChatRoom('assets/images/manee_profile.png',
                        'มานี มีนา', 'ขอลดหน่อยได้มั้ย', 'เมื่อวาน\n8:10 AM'),
                    _buildChatRoom(
                        'assets/images/tony_profile.png',
                        'โทนี่ พีรศักดิ์',
                        'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
                        '30 พ.ย.\n11:12 PM'),
                    _buildChatRoom(
                        'assets/images/tony_profile.png',
                        'โทนี่ พีรศักดิ์',
                        'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
                        '30 พ.ย.\n11:12 PM'),
                    _buildChatRoom(
                        'assets/images/tony_profile.png',
                        'โทนี่ พีรศักดิ์',
                        'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
                        '30 พ.ย.\n11:12 PM'),
                    _buildChatRoom(
                        'assets/images/tony_profile.png',
                        'โทนี่ พีรศักดิ์',
                        'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
                        '30 พ.ย.\n11:12 PM'),
                    _buildChatRoom(
                        'assets/images/tony_profile.png',
                        'โทนี่ พีรศักดิ์',
                        'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
                        '30 พ.ย.\n11:12 PM'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          onTap: () {
            isSearching = true;
            setState(() {});
          },
          controller: searchUserEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            hintText: 'ค้นหา',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: isSearching
                ? GestureDetector(
                    onTap: () {
                      isSearching = false;
                      searchUserEditingController.text = "";
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {});
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.close,),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: const BorderSide(
                width: 2,
                color: outlineColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: const BorderSide(
                width: 2,
                color: outlineColor,
              ),
            ),
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildChatRoom(profileImage, name, lastMessage, timestamp) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/chat_detail');
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
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
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 2),
              Text(lastMessage,
                  style: const TextStyle(color: Colors.black54, fontSize: 16))
            ],
          ),
        ),
        Text(timestamp,
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400),
            textAlign: TextAlign.right),
      ]),
    );
  }
}
