import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/contract_card.dart';

class ContractManagementScreen extends StatefulWidget {
  const ContractManagementScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<ContractManagementScreen> createState() =>
      _ContractManagementScreenState();

  final String userType;

  static const String routeName = '/contract_management';

  static Route route({required String userType}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ContractManagementScreen(userType: userType),
    );
  }
}

class _ContractManagementScreenState extends State<ContractManagementScreen> {
  List renterStatusList = [
    'รอการอนุมัติ',
    'ที่ต้องชำระ',
    'ที่ต้องได้รับ',
    'ที่ต้องส่งคืน',
    'รอการจบสัญญา',
    'สำเร็จ',
    'ยกเลิกแล้ว',
    'ข้อพิพาท'
  ];
  
  List ownerStatusList = [
    'รอการอนุมัติ',
    'รอการชำระ',
    'ที่ต้องจัดส่ง',
    'ที่ต้องได้คืน',
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
            userType: widget.userType,
          );
        });
  }

  Widget _buildRenterContract(status) {
    return StreamBuilder<QuerySnapshot>(
        stream: contracts
            .where('renterStatus', isEqualTo: status)
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

    Widget _buildOwnerContract(status) {
    return StreamBuilder<QuerySnapshot>(
        stream: contracts
            .where('ownerStatus', isEqualTo: status)
            .where('ownerId',
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
    return widget.userType == 'renter' ? 
    DefaultTabController(
      length: renterStatusList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "สัญญาของผู้เช่า",
          ),
          bottom: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                for (var status in renterStatusList)
                  Tab(
                    child: Text(status),
                  ),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            for (var status in renterStatusList) _buildRenterContract(status),
          ],
        ),
      ),
    ):DefaultTabController(
      length: ownerStatusList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "สัญญาของผู้ให้เช่า",
          ),
          bottom: TabBar(
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                for (var status in ownerStatusList)
                  Tab(
                    child: Text(status),
                  ),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            for (var status in ownerStatusList) _buildOwnerContract(status),
          ],
        ),
      ),
    );
  }
}
