import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';

class KYC extends StatefulWidget {
  const KYC({Key? key}) : super(key: key);

  @override
  State<KYC> createState() => _KYCState();
}

class _KYCState extends State<KYC> {
  bool uploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ยืนยันตัวตน KYC',
                  style: textTheme().headline4,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: IconButton(
                              onPressed: () {
                                debugPrint('test');
                              },
                              icon: const Icon(Icons.photo_camera),
                              iconSize: 50,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'รูปถ่ายหน้าบัตรประชาชน',
                            style: textTheme().subtitle1,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.photo_camera),
                              iconSize: 50,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'รูปถ่ายหลังบัตรประชาชน',
                            style: textTheme().subtitle1,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.photo_camera),
                              iconSize: 50,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'รูปถ่ายถือบัตรประชาชนคู่กับใบหน้า',
                            style: textTheme().subtitle1,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'แสดงตัวอย่าง',
                              style: textTheme().bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: uploaded ? null : null,
                        child: Text(
                          'ดำเนินการต่อ',
                          style: textTheme().button,
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor:
                              uploaded ? primaryColor : primaryLightColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'ดำเนินการภายหลัง',
                    style: textTheme().bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
