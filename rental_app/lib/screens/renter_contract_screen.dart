import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List statusList = [
    'รอการอนุมัติ',
    'ที่ต้องได้รับ',
    'ที่ต้องชำระ',
    'กำลังใช้',
    'ที่ต้องส่งคืน',
    'ยืนยันจบสัญญา',
    'สำเร็จ',
    'ยกเลิกแล้ว',
    'ข้อพิพาท'
  ];
  CollectionReference contracts =
      FirebaseFirestore.instance.collection("contracts");

  Widget _buildContractList(data) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: data.docs.length,
        separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
        itemBuilder: (BuildContext context, int index) {
          return ContractCard(
            contract: Contract.fromSnapshot(data.docs[index]),
          );
        });
  }

  Widget _buildStreamContractList(status) {
    return StreamBuilder<QuerySnapshot>(
        stream: contracts
            .where('status', isEqualTo: status)
            .where('renterId',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
          return _buildContractList(data);
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: statusList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "สัญญาเช่า",
          ),
          bottom: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              //indicatorColor: Colors.white,
              tabs: [
                for (var status in statusList)
                  Tab(
                    child: Text(status),
                  ),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            for (var status in statusList) _buildStreamContractList(status),
          ],
        ),
      ),
    );
  }
}
