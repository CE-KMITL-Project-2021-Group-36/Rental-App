import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/contract_card.dart';
import 'package:rental_app/widgets/widget.dart';

class ContractManagementScreen extends StatefulWidget {
  const ContractManagementScreen({Key? key}) : super(key: key);

  @override
  State<ContractManagementScreen> createState() =>
      _ContractManagementScreenState();

  static const String routeName = '/contract_management';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ContractManagementScreen(),
    );
  }
}

class _ContractManagementScreenState extends State<ContractManagementScreen> {
  String labelTab1 = 'รอการอนุมัติ';
  String labelTab2 = 'ที่ต้องชำระ';
  String labelTab3 = 'ที่ต้องได้รับ';
  String labelTab4 = 'ที่ต้องส่งคืน';
  String labelTab5 = 'ยืนยันจบสัญญา';
  String labelTab6 = 'สำเร็จ';
  String labelTab7 = 'ยกเลิกแล้ว';
  String labelTab8 = 'ข้อพิพาท';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "สัญญาเช่า",
          ),
          bottom: const TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              //indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text("รอการอนุมัติ"),
                ),
                Tab(
                  child: Text("ที่ต้องชำระ"),
                ),
                Tab(
                  child: Text("ที่ต้องได้รับ"),
                ),
                Tab(
                  child: Text("ที่ต้องส่งคืน"),
                ),
                Tab(
                  child: Text("ยืนยันจบสัญญา"),
                ),
                Tab(
                  child: Text("สำเร็จ"),
                ),
                Tab(
                  child: Text("ยกเลิกแล้ว"),
                ),
                Tab(
                  child: Text("ข้อพิพาท"),
                ),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      //.where('category', isEqualTo: 'zzzzzzzz')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: 'รอการอนุมัติ'),
                    );
                    // Expanded(
                    //   child: ListView.builder(
                    //     physics: const BouncingScrollPhysics(),
                    //         shrinkWrap: true,
                    //       padding: const EdgeInsets.all(16),
                    //       itemCount: data.docs.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return ContractCard();
                    //       }),
                    // );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab2),
                    );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab3),
                    );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab4),
                    );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab5),
                    );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab6),
                    );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab7),
                    );
                  }),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("contract")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Somthing went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ContractCard(type: labelTab8),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
