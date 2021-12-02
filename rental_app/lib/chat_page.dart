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
          centerTitle: true,
          title: const Text(
            'ข้อความ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          children: [
            Text('1'),
            Text('2'),
            Text('3'),
          ],
        ),
      ),
    );
  }
}
