import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/services/database.dart';

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
  Stream? userStream;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController searchUserEditingController = TextEditingController();

  onSearch() async {
    isSearching = true;
    setState(() {});
  }

  Widget _buildChatsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .where('users', arrayContains: currentUserId)
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
        final chatData = snapshot.data;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: chatData!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot chat = chatData.docs[index];
            String? chatUserId;
            for (final i in chat['users']) {
              if (i != currentUserId) {
                chatUserId = i;
                break;
              }
            }
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(chatUserId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                final userData = snapshot.data;
                final avatarUrl = userData!['avatarUrl'];
                final userName =
                    '${userData['firstName']} ${userData['lastName']}';
                return _buildUserChat(
                  avatarUrl,
                  userName,
                  chat['lastestMessage'],
                );
              },
            );
          },
        );
      },
    );
  }

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
            _buildChatsList(),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         _buildChatRoom('assets/images/shop_profile.png',
            //             'RentKlong', 'ได้ครับ😀', 'วันนี้\n9:10 PM'),
            //         _buildChatRoom('assets/images/manee_profile.png',
            //             'มานี มีนา', 'ขอลดหน่อยได้มั้ย', 'เมื่อวาน\n8:10 AM'),
            //         _buildChatRoom(
            //             'assets/images/tony_profile.png',
            //             'โทนี่ พีรศักดิ์',
            //             'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
            //             '30 พ.ย.\n11:12 PM'),
            //         _buildChatRoom(
            //             'assets/images/tony_profile.png',
            //             'โทนี่ พีรศักดิ์',
            //             'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
            //             '30 พ.ย.\n11:12 PM'),
            //         _buildChatRoom(
            //             'assets/images/tony_profile.png',
            //             'โทนี่ พีรศักดิ์',
            //             'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
            //             '30 พ.ย.\n11:12 PM'),
            //         _buildChatRoom(
            //             'assets/images/tony_profile.png',
            //             'โทนี่ พีรศักดิ์',
            //             'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
            //             '30 พ.ย.\n11:12 PM'),
            //         _buildChatRoom(
            //             'assets/images/tony_profile.png',
            //             'โทนี่ พีรศักดิ์',
            //             'ขอดูสินค้าเพิ่มเติมหน่อยครับ',
            //             '30 พ.ย.\n11:12 PM'),
            //       ],
            //     ),
            //   ),
            // ),
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
            if (searchUserEditingController.text != '') {
              onSearch();
            }
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
                      child: Icon(
                        Icons.close,
                      ),
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

  Widget _buildUserChat(avatarUrl, name, lastest) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(avatarUrl),
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
                Text(lastest,
                    style: const TextStyle(color: Colors.grey, fontSize: 16))
              ],
            ),
          ),
          // Text(
          //   timestamp,
          //   style: const TextStyle(
          //       fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400),
          //   textAlign: TextAlign.right,
          // ),
        ],
      ),
    );
  }
}
