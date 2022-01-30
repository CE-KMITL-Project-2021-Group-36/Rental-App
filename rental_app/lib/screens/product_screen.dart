import 'package:flutter/material.dart';
import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:rental_app/config/palette.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();

  static const String routeName = '/product';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ProductScreen(),
    );
  }
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 2,
                child: TextButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Icon(Icons.chat_bubble),
                        Text('ส่งข้อความ'),
                      ],
                    ),
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 14))))),
            const SizedBox(width: 8),
            Expanded(
                flex: 2,
                child: TextButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Icon(Icons.shopping_cart),
                        Text('ใส่รถเข็น'),
                      ],
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor.withOpacity(0.2)),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 14))))),
            const SizedBox(width: 8),
            Expanded(
                flex: 3,
                child: TextButton(
                    onPressed: () {},
                    child: const Text('ส่งคำขอเช่า'),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 14))))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: Carousel(
                  boxFit: BoxFit.cover,
                  images: const [
                    NetworkImage(
                        'https://www.ec-mall.com/wp-content/uploads/2018/03/eos-1500d_02-1-768x768.jpg'),
                    NetworkImage(
                        'https://www.ec-mall.com/wp-content/uploads/2018/03/Canon-EOS-1500D_2.jpg'),
                    NetworkImage(
                        'https://www.ec-mall.com/wp-content/uploads/2018/03/Canon-EOS-1500D_3.jpg'),
                    NetworkImage(
                        'https://www.ec-mall.com/wp-content/uploads/2018/03/Canon-EOS-1500D_4.jpg'),
                  ],
                  dotSize: 8.0,
                  dotSpacing: 25.0,
                  dotBgColor: Colors.grey[800]!.withOpacity(0.25),
                )),
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก',
                          style: TextStyle(
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Container(
                    height: 32,
                    child: Row(children: [
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.yellow[600], size: 24),
                          Icon(Icons.star,
                              color: Colors.yellow[600], size: 24),
                          Icon(Icons.star,
                              color: Colors.yellow[600], size: 24),
                          Icon(Icons.star,
                              color: Colors.yellow[600], size: 24),
                          Icon(Icons.star_half,
                              color: Colors.yellow[600], size: 24),
                        ],
                      ),
                      const Text('4.9'),
                      const VerticalDivider(
                        color: Colors.grey,
                      ),
                      const Text('เช่าแล้ว 33 ครั้ง'),
                    ]),
                  ),
                  const Text('ราคาเช่า'),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    '฿100 /ชม.\n฿700 /วัน\n฿4,500 /สัปดาห์',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'ค่ามัดจำ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '''
ราคาสินค้าจริง ฿50,000
เอกสาร 1 ชิ้น: 90% ของราคาสินค้า - ฿45,000
เอกสาร 2 ชิ้น: 70% ของราคาสินค้า - ฿35,000
เอกสาร 3 ชิ้น: 50% ของราคาสินค้า - ฿25,000
บัตรนักศึกษา: 30% ของราคาสินค้า - ฿15,000''',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'การจัดส่ง/รับของ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'รับสินค้าที่ร้าน',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'ฟรี',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'นัดรับสินค้า',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'ฟรี',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ส่งด่วนในบริเวณ',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'ตามระยะทาง',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ส่งไปรษณีย์แบบธรรมดา',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '฿40',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ส่งไปรษณีย์แบบ EMS',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '฿60',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'รายละเอียด',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '''
      กล้องรุ่น EOS 1500D + เลนส์ Kit (EF S18-55 IS II) กล้องสภาพดีมาก ใช้งานได้ปกติ
      - เซ็นเซอร์ CMOS APS-C ความละเอียด 24.1 ล้านพิกเซล และชิปประมวลผลภาพ DIGIC 4+
      - ระบบออโต้โฟกัส 9 จุด พร้อมออโต้โฟกัสแบบ cross-type 1 จุดตรงกลางภาพ
      - ความไวแสงมาตรฐาน ISO 100 - 6400 (ขยายได้ถึง ISO 12800)
      - รองรับ Wi-Fi / NFC''',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/shop_profile.png'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.storefront,
                                    color: Colors.black, size: 16),
                                Text('RentKlong',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(Icons.location_on,
                                    color: Colors.red, size: 16),
                                Text('จตุจักร, กรุงเทพ')
                              ],
                            ),
                          ]),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'ดูร้านค้า',
                        ),
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                BorderSide(width: 1, color: Colors.indigo)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.indigo),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16)),
                            textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 14,
                            )))),
                  ]),
                  Text('10 รายการสินค้า'),
                  Text('64 รายการสินค้า'),
                ],
              ),
            ),
            Container(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'คะแนนสินค้า',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    child: Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.yellow[600],
                                            size: 16),
                                        Icon(Icons.star,
                                            color: Colors.yellow[600],
                                            size: 16),
                                        Icon(Icons.star,
                                            color: Colors.yellow[600],
                                            size: 16),
                                        Icon(Icons.star,
                                            color: Colors.yellow[600],
                                            size: 16),
                                        Icon(Icons.star_half,
                                            color: Colors.yellow[600],
                                            size: 16),
                                        Row(
                                          children: const [
                                            Text(
                                              '4.5/5',
                                              style: TextStyle(
                                                color: Colors.indigo,
                                              ),
                                            ),
                                            Text('(6 รีวิว)'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const <Widget>[
                                Flexible(child: Text('ดูทั้งหมด')),
                                Icon(
                                  Icons.chevron_right,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                        'assets/images/manee_profile.png'),
                                  ),
                                  SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text('มานี'),
                                      Text('06-09-2021 21:24',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12))
                                    ],
                                  )
                                ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.star,
                                  color: Colors.yellow[600], size: 16),
                              Icon(Icons.star,
                                  color: Colors.yellow[600], size: 16),
                              Icon(Icons.star,
                                  color: Colors.yellow[600], size: 16),
                              Icon(Icons.star,
                                  color: Colors.yellow[600], size: 16),
                              Icon(Icons.star,
                                  color: Colors.yellow[600], size: 16),
                            ]),
                            const SizedBox(height: 4),
                            Text('ตอบกลับไวมากค่ะ ได้ของครบ สภาพดีมากก'),
                            const SizedBox(height: 4),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/review_image1.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/review_image2.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/review_image3.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                              ]),
                            ),
                          ],
                        )),
                    const Divider(
                      height: 0,
                    ),
                    Container(
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () {}, child: Text('ดูทั้งหมด'))),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
