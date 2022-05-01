import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/providers/authentication_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final CollectionReference contracts =
        FirebaseFirestore.instance.collection('contracts');

    final _auth = ref.watch(authenticationProvider);

    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      return StreamBuilder<DocumentSnapshot>(
          stream: users.doc(userId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('มีบางอย่างผิดพลาด'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final String displayName =
                    '${data['firstName']} ${data['lastName']}',
                kycStatus = data['kyc']['status'],
                avatarUrl = data['avatarUrl'] ??=
                    'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4';
            final double? balance = data['wallet']?['balance'];
            final bool kycVerified = data['kyc']['verified'];
            final bool hasShop = data['shop']['hasShop'];
            final bool isVerified = data['kyc']['verified'];

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 175,
                          color: primaryColor,
                        ),
                        Positioned(
                          top: 50,
                          child: TextButton(
                            onPressed: () => isVerified
                                ? hasShop
                                    ? Navigator.pushNamed(
                                        context, '/owner_account')
                                    : Navigator.pushNamed(context, '/add_shop')
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('กรุณายืนยันตัวตน'),
                                          content: const Text(
                                              'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                'ดำเนินการภายหลัง',
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pushNamed(
                                                      context, '/kyc',
                                                      arguments: data['kyc']
                                                          ['status']),
                                              child: const Text('ยืนยันตัวตน'),
                                            ),
                                          ],
                                        )),
                            child: Row(
                              children: [
                                Text(
                                  'ร้านของฉัน',
                                  style: textTheme().bodyText2,
                                ),
                                const Icon(Icons.chevron_right)
                              ],
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 3.0, 5.0, 3.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              primary: textColor,
                              backgroundColor: primaryLightColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 40,
                            right: 5,
                            child: IconButton(
                              icon: const Icon(
                                Icons.help,
                                color: primaryLightColor,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/about');
                              },
                            )),
                        Positioned(
                          bottom: 15,
                          left: 20,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              avatarUrl,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 95,
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              color: primaryLightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 22,
                          left: 95,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              kycStatus,
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              primary:
                                  kycVerified ? textColor : primaryLightColor,
                              backgroundColor:
                                  kycVerified ? secondaryColor : errorColor,
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 3.0, 10.0, 3.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Row(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.clipboardList,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'สัญญาเช่า',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  top: 10,
                                  left: 10,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () => isVerified
                                        ? Navigator.pushNamed(
                                            context, '/contract_management',
                                            arguments: ['renter', '0'])
                                        : showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      'กรุณายืนยันตัวตน'),
                                                  content: const Text(
                                                      'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                        'ดำเนินการภายหลัง',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pushNamed(
                                                              context, '/kyc',
                                                              arguments: data[
                                                                      'kyc']
                                                                  ['status']),
                                                      child: const Text(
                                                          'ยืนยันตัวตน'),
                                                    ),
                                                  ],
                                                )),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'ดูทั้งหมด',
                                        ),
                                        Icon(Icons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 55,
                                  left: 5,
                                  right: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('renterId',
                                                    isEqualTo: userId)
                                                .where('renterStatus',
                                                    isEqualTo: 'รอการอนุมัติ')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int waitingForApproval =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () => isVerified
                                                    ? Navigator.pushNamed(
                                                        context,
                                                        '/contract_management',
                                                        arguments: [
                                                            'renter',
                                                            '0'
                                                          ])
                                                    : showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'กรุณายืนยันตัวตน'),
                                                                  content:
                                                                      const Text(
                                                                          'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          const Text(
                                                                        'ดำเนินการภายหลัง',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pushNamed(
                                                                          context,
                                                                          '/kyc',
                                                                          arguments:
                                                                              data['kyc']['status']),
                                                                      child: const Text(
                                                                          'ยืนยันตัวตน'),
                                                                    ),
                                                                  ],
                                                                )),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons
                                                            .clipboardQuestion,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$waitingForApproval'),
                                                      showBadge:
                                                          waitingForApproval > 0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'รอการอนุมัติ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('renterId',
                                                    isEqualTo: userId)
                                                .where('renterStatus',
                                                    isEqualTo: 'ที่ต้องชำระ')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int needToPay =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () => isVerified
                                                    ? Navigator.pushNamed(
                                                        context,
                                                        '/contract_management',
                                                        arguments: [
                                                            'renter',
                                                            '1'
                                                          ])
                                                    : showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'กรุณายืนยันตัวตน'),
                                                                  content:
                                                                      const Text(
                                                                          'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          const Text(
                                                                        'ดำเนินการภายหลัง',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pushNamed(
                                                                          context,
                                                                          '/kyc',
                                                                          arguments:
                                                                              data['kyc']['status']),
                                                                      child: const Text(
                                                                          'ยืนยันตัวตน'),
                                                                    ),
                                                                  ],
                                                                )),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons.wallet,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent:
                                                          Text('$needToPay'),
                                                      showBadge: needToPay > 0
                                                          ? true
                                                          : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'ที่ต้องชำระ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('renterId',
                                                    isEqualTo: userId)
                                                .where('renterStatus',
                                                    isEqualTo: 'ที่ต้องได้รับ')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int onTheWay =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () => isVerified
                                                    ? Navigator.pushNamed(
                                                        context,
                                                        '/contract_management',
                                                        arguments: [
                                                            'renter',
                                                            '2'
                                                          ])
                                                    : showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'กรุณายืนยันตัวตน'),
                                                                  content:
                                                                      const Text(
                                                                          'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          const Text(
                                                                        'ดำเนินการภายหลัง',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pushNamed(
                                                                          context,
                                                                          '/kyc',
                                                                          arguments:
                                                                              data['kyc']['status']),
                                                                      child: const Text(
                                                                          'ยืนยันตัวตน'),
                                                                    ),
                                                                  ],
                                                                )),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons.truck,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent:
                                                          Text('$onTheWay'),
                                                      showBadge: onTheWay > 0
                                                          ? true
                                                          : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'ที่ต้องได้รับ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('renterId',
                                                    isEqualTo: userId)
                                                .where('renterStatus',
                                                    isEqualTo: 'ที่ต้องส่งคืน')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int needToSendBack =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () => isVerified
                                                    ? Navigator.pushNamed(
                                                        context,
                                                        '/contract_management',
                                                        arguments: [
                                                            'renter',
                                                            '3'
                                                          ])
                                                    : showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'กรุณายืนยันตัวตน'),
                                                                  content:
                                                                      const Text(
                                                                          'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          const Text(
                                                                        'ดำเนินการภายหลัง',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pushNamed(
                                                                          context,
                                                                          '/kyc',
                                                                          arguments:
                                                                              data['kyc']['status']),
                                                                      child: const Text(
                                                                          'ยืนยันตัวตน'),
                                                                    ),
                                                                  ],
                                                                )),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons.box,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$needToSendBack'),
                                                      showBadge:
                                                          needToSendBack > 0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'ที่ต้องส่งคืน',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: contracts
                                                .where('renterId',
                                                    isEqualTo: userId)
                                                .where('renterStatus',
                                                    isEqualTo: 'สำเร็จ')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'มีบางอย่างผิดพลาด'));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final int finishedCount =
                                                  snapshot.data!.size;
                                              return InkWell(
                                                onTap: () => isVerified
                                                    ? Navigator.pushNamed(
                                                        context,
                                                        '/contract_management',
                                                        arguments: [
                                                            'renter',
                                                            '5'
                                                          ])
                                                    : showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'กรุณายืนยันตัวตน'),
                                                                  content:
                                                                      const Text(
                                                                          'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          const Text(
                                                                        'ดำเนินการภายหลัง',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pushNamed(
                                                                          context,
                                                                          '/kyc',
                                                                          arguments:
                                                                              data['kyc']['status']),
                                                                      child: const Text(
                                                                          'ยืนยันตัวตน'),
                                                                    ),
                                                                  ],
                                                                )),
                                                child: Column(
                                                  children: [
                                                    Badge(
                                                      child: const Icon(
                                                        FontAwesomeIcons
                                                            .clipboardCheck,
                                                        color: primaryColor,
                                                      ),
                                                      badgeContent: Text(
                                                          '$finishedCount'),
                                                      showBadge:
                                                          finishedCount > 0
                                                              ? true
                                                              : false,
                                                      badgeColor: warningColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'สำเร็จ',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () => isVerified
                                ? Navigator.pushNamed(
                                    context, '/wallet_input_passcode',
                                    arguments: 'wallet')
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('กรุณายืนยันตัวตน'),
                                          content: const Text(
                                              'จำเป็นต้องยืนยันตัวตนเพื่อใช้งานฟีเจอร์นี้'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                'ดำเนินการภายหลัง',
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pushNamed(
                                                      context, '/kyc',
                                                      arguments: data['kyc']
                                                          ['status']),
                                              child: const Text('ยืนยันตัวตน'),
                                            ),
                                          ],
                                        )),
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.wallet,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Wallet',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    top: 10,
                                    left: 10,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Row(
                                      children: const [
                                        Text(
                                          'ดูรายละเอียด',
                                        ),
                                        Icon(Icons.chevron_right)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Text(
                                      balance != null
                                          ? '฿' + currencyFormat(balance)
                                          : '฿ 0.00',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (!isVerified)
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/kyc',
                                    arguments: data['kyc']['status']);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Ink(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: primaryLightColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(
                                            FontAwesomeIcons.userCheck,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'ยืนยันตัวตน',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(kycStatus),
                                          const Icon(Icons.chevron_right),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/edit_profile');
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.pen,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'แก้ไขข้อมูล และจัดการบัญชี',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/report',
                                  arguments: displayName);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.announcement,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'รายงานปัญหา',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/');
                              _auth.signOut();
                            },
                            child: Ink(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                  // color: Colors.redAccent.shade100,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1.25,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      Icons.logout,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return Scaffold(
        body: Center(
          // child: TextButton(
          //   child: Text('ลงชื่อเข้าใช้ หรือ สมัครสมาชิก'),
          //   onPressed: () {},
          // ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      'ลงชื่อเข้าใช้ หรือ สมัครสมาชิก',
                      style: textTheme().button,
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
