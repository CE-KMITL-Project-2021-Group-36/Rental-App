import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();

  static const String routeName = '/notification';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const NotificationScreen(),
    );
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'แจ้งเตือน',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 2,
          bottom: const TabBar(
            labelColor: primaryColor,
            tabs: [
              Tab(
                text: 'แจ้งเตือนฝั่งผู้เช่า',
              ),
              Tab(
                text: 'แจ้งเตือนฝั่งผู้ให้เช่า',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRenterNotificationList(),
            _buildOwnerNotificationList()
          ],
        ),
      ),
    );
  }

  Widget _buildRenterNotificationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('notifications')
          .where('type', isEqualTo: 'renter')
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
        final data = snapshot.data;
        return data?.size == 0
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('ไม่มีการแจ้งเตือน')),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = data.docs[index];
                  return _buildNotificationWithIcon(doc['title'], doc['text']);
                },
              );
      },
    );
  }

  Widget _buildOwnerNotificationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('notifications')
          .where('type', isEqualTo: 'owner')
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
        final data = snapshot.data;
        return data?.size == 0
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('ไม่มีการแจ้งเตือน')),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = data.docs[index];
                  return _buildNotificationWithIcon(doc['title'], doc['text']);
                },
              );
      },
    );
  }

  _buildNotificationWithIcon(title, text) {
    switch (title) {
      case 'กรุณาชำระค่าเช่า':
        return _buildNotificationCard(
          icon: Icons.paid,
          title: title,
          subtitle: text,
        );
      case 'สินค้าจัดส่งแล้ว':
        return _buildNotificationCard(
          icon: Icons.local_shipping,
          title: title,
          subtitle: text,
        );
      case 'การเช่าสำเร็จ':
        return _buildNotificationCard(
          icon: Icons.verified,
          title: title,
          subtitle: text,
        );
      case 'มีคำขอเช่าใหม่':
        return _buildNotificationCard(
          icon: Icons.mail,
          title: title,
          subtitle: text,
        );
      case 'ผู้เช่าได้รับสินค้าแล้ว':
        return _buildNotificationCard(
          icon: Icons.done,
          title: title,
          subtitle: text,
        );
      case 'ผู้เช่าจัดส่งสินค้าแล้ว':
        return _buildNotificationCard(
          icon: Icons.local_shipping,
          title: title,
          subtitle: text,
        );
    }
  }

  Widget _buildNotificationCard({icon, title, subtitle}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          horizontalTitleGap: 2,
          leading: Icon(icon, color: primaryColor),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void sendNotification({receiver, title, text, type}) async {
    CollectionReference notification = FirebaseFirestore.instance
        .collection('users')
        .doc(receiver)
        .collection('notifications');
    await sendPushNotification();
    await notification.add({
      'createdOn': DateTime.now(),
      'title': title,
      'text': text,
      'type': type,
    });
  }

  sendPushNotification() {}
}
