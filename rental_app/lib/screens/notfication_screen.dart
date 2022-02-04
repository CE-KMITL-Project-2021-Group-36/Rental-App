import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key? key }) : super(key: key);

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
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationCard(Icons.timer,'ระยะเวลาเช่าใกล้หมดแล้ว','รายการ: กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก กำลังจะหมดระยะเวลาเช่าใน 3 วัน',),
                    _buildNotificationCard(Icons.local_shipping,'สินค้าส่งถึงแล้ว','รายการ: กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก สินค้าถูกจัดส่งแล้ว กรุณาตรวจสอบสินค้า',),
                    _buildNotificationCard(Icons.local_shipping,'สินค้ากำลังถูกจัดส่ง','รายการ: กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก สินค้ากำลังจัดส่งโดยไปรษณีย์ไทย',),
                    _buildNotificationCard(Icons.local_shipping,'ร้านค้ากำลังเตรียมจัดส่ง','รายการ: กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก ร้าน RentKlong รับคำขอเช่าแล้วกำลังเตรียมจัดส่ง',),
                  ]),
            ),
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationCard(Icons.timer,'ระยะเวลาเช่าหมดแล้ว','รายการ: เสื้อเชิ้ทสีกรม กำลังหมดระยะเวลาเช่าแล้วกำลังรอการคืนของจากผู้เช่า',),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(icon, title, subtitle,) {
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
          title: Text(title),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),
          ),
        )
      ),
    );
  }
}