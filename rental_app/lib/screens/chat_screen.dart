import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  List userNameList = [];

  TextEditingController searchUserEditingController = TextEditingController();

  onSearch() async {
    isSearching = true;
    userNameList = userNameList.where((userName) {
      final nameLower = userName.toLowerCase();
      final searchLower = searchUserEditingController.text.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      userNameList = userNameList;
    });
    print(userNameList);
  }

  Widget _buildChatsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .where('usersInChat', arrayContains: currentUserId)
          .orderBy('lastestMessageCreatedOn', descending: true)
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
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: chatData!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot chat = chatData.docs[index];
            String? chatWithUserId;
            for (final i in chat['usersInChat']) {
              if (i != currentUserId) {
                chatWithUserId = i;
                break;
              }
            }
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(chatWithUserId)
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
                final chatWithUserName =
                    '${userData['firstName']} ${userData['lastName']}';
                return _buildUserChat(
                  chat.id,
                  avatarUrl,
                  chatWithUserName,
                  chat['lastestMessage'],
                  chat['lastestMessageSender'],
                  chat['lastestMessageCreatedOn'],
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
              onPressed: () async {
                enterChatRoom(context, currentUserId, 'admin');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            isSearching
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('ไม่พบการค้นหา'),
                  )
                : _buildChatsList(),
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
            onSearch();
            if (searchUserEditingController.text != '') {}
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
                      userNameList = [];
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

  Widget _buildUserChat(
      String chatId,
      String avatarUrl,
      String name,
      String lastestMessage,
      String lastestMessageSender,
      lastestMessageCreatedOn) {
    bool isMylastestMessage = currentUserId == lastestMessageSender;
    initializeDateFormatting('th', null);
    String date =
        DateFormat('dd MMM', 'th').format(lastestMessageCreatedOn.toDate());
    String time =
        DateFormat('hh:mm a').format(lastestMessageCreatedOn.toDate());

    lastestMessage =
        isMylastestMessage ? 'คุณ: $lastestMessage' : lastestMessage;
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              chatWithUserName: name,
              chatId: chatId,
            ),
          ),
        );
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
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  lastestMessage,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> enterChatRoom(context, currentUser, chatWithUser) async {
  final chats = FirebaseFirestore.instance.collection('chats');
  String chatId;
  final snapshot = await chats
      .where("usersCheck.$currentUser", isEqualTo: true)
      .where("usersCheck.$chatWithUser", isEqualTo: true)
      .get();
  if (snapshot.docs.isEmpty) {
    var chatRef = await FirebaseFirestore.instance.collection('chats').add({
      'lastestMessage': '',
      'usersInChat': [currentUser, chatWithUser],
      'usersCheck': {currentUser: true, chatWithUser: true},
    });
    chatId = chatRef.id;
  } else {
    chatId = snapshot.docs[0].id;
  }

  String firstName = '';
  String lastName = '';
  var collection = FirebaseFirestore.instance.collection('users');
  var docSnapshot = await collection.doc(chatWithUser).get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    firstName = data?['firstName'];
    lastName = data?['lastName'];
  }
  String userName = '$firstName $lastName';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatDetailScreen(
        chatId: chatId,
        chatWithUserName: userName,
      ),
    ),
  );
}
