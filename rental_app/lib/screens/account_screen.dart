import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/providers/authentication_provider.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(firebaseAuthProvider);
    final _auth = ref.watch(authenticationProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  color: primaryColor,
                ),
                Positioned(
                  top: 20,
                  child: TextButton(
                    onPressed: () {},
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
                      padding: const EdgeInsets.fromLTRB(10.0, 3.0, 5.0, 3.0),
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
                const Positioned(
                  top: 70,
                  left: 20,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/147/147144.png',
                    ),
                  ),
                ),
                const Positioned(
                  top: 80,
                  left: 95,
                  child: Text(
                    'มานี มีนา',
                    style: TextStyle(
                      color: primaryLightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  top: 105,
                  left: 95,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'ยืนยันตัวตนแล้ว',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      primary: textColor,
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
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
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                            onTap: () {},
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
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: const [
                                  Icon(FontAwesomeIcons.clipboardQuestion),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'รอการอนุมัติ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  Icon(FontAwesomeIcons.wallet),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'ที่ต้องชำระ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  Icon(FontAwesomeIcons.truck),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'ที่ต้องได้รับ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  Icon(FontAwesomeIcons.box),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'ที่ต้องส่งคืน',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  Icon(FontAwesomeIcons.clipboardCheck),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'ยืนยันจบสัญญา',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
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
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
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
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: const [
                                  Text(
                                    'เพิ่มเติม',
                                  ),
                                  Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 10,
                            right: 10,
                            child: Text(
                              '฿50,000.00',
                              style: TextStyle(
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
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          color: primaryLightColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.solidHeart,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'สิ่งที่ฉันถูกใจ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          color: primaryLightColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('ยืนยันตัวตนแล้ว'),
                                Icon(Icons.chevron_right),
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
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          color: primaryLightColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          color: primaryLightColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.logout,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'ออกจากระบบ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
        // child: ListView(
        //   padding: const EdgeInsets.all(20),
        //   children: [
        //     SizedBox(
        //       height: 200,
        //       child: Image.network(
        //         data.currentUser!.photoURL ??
        //             'https://cdn-icons-png.flaticon.com/512/147/147144.png',
        //       ),
        //     ),
        //     SizedBox(
        //       height: 50,
        //       child: Text(data.currentUser!.email ?? 'เข้าสู่ระบบแล้ว'),
        //     ),
        //     SizedBox(
        //       height: 50,
        //       child: Text(data.currentUser!.displayName ?? 'ชื่อ นามสกุล'),
        //     ),
        //
        //     TextButton(
        //       onPressed: () {
        //         // Navigator.of(context).pop();
        //         Navigator.of(context).pushReplacementNamed('/');
        //         _auth.signOut();
        //       },
        //       child: const Text(
        //         'ออกจากระบบ',
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       style: TextButton.styleFrom(
        //         primary: Colors.white,
        //         backgroundColor: primaryColor,
        //         padding: const EdgeInsets.symmetric(vertical: 15),
        //       ),
        //     ),
        //     TextButton(
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/user_store');
        //       },
        //       child: const Text(
        //         'ร้านของคุณ',
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     TextButton(
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/kyc');
        //       },
        //       child: const Text(
        //         'ยืนยันตัวตน KYC',
        //         style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     // Container(
        //     //   padding: const EdgeInsets.only(top: 48.0),
        //     //   margin: const EdgeInsets.symmetric(horizontal: 16),
        //     //   width: double.infinity,
        //     //   child: MaterialButton(
        //     //     onPressed: () => _auth.signOut(),
        //     //     child: const Text(
        //     //       'Log Out',
        //     //       style: TextStyle(fontWeight: FontWeight.w600),
        //     //     ),
        //     //     textColor: Colors.blue.shade700,
        //     //     textTheme: ButtonTextTheme.primary,
        //     //     minWidth: 100,
        //     //     padding: const EdgeInsets.all(18),
        //     //     shape: RoundedRectangleBorder(
        //     //       borderRadius: BorderRadius.circular(25),
        //     //       side: BorderSide(color: Colors.blue.shade700),
        //     //     ),
        //     //   ),
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}
