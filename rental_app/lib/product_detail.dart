import 'package:flutter/material.dart';
import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:rental_app/bottom_nav_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.indigo),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.indigo,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.indigo,
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
                      children: [
                        Icon(Icons.chat_bubble),
                        Text('ส่งข้อความ'),
                      ],
                    ),
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 14))))),
            const SizedBox(width: 8),
            Expanded(
                flex: 2,
                child: TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.shopping_cart),
                        Text('ใส่รถเข็น'),
                      ],
                    ),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.indigo),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo[50]),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 14))))),
            const SizedBox(width: 8),
            Expanded(
                flex: 3,
                child: TextButton(
                    onPressed: () {},
                    child: Text('ส่งคำขอเช่า'),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 14))))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.indigo[100],
          child: Column(
            children: [
              Container(
                  //color: Colors.lightGreen,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    images: [
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
                        Expanded(
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
                          icon: Icon(
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
                        Text('4.9'),
                        VerticalDivider(
                          color: Colors.grey,
                        ),
                        Text('เช่าแล้ว 33 ครั้ง'),
                      ]),
                    ),
                    Text('ราคาเช่า'),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '฿100 /ชม.\n฿700 /วัน\n฿4,500 /สัปดาห์',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo,
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
                      Text(
                        'การจัดส่ง/รับของ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                        children: [
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
                        children: [
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
                        children: [
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
                        children: [
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
                                children: [
                                  Icon(Icons.storefront,
                                      color: Colors.black, size: 16),
                                  Text('RentKlong',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.red, size: 16),
                                  Text('จตุจักร, กรุงเทพ')
                                ],
                              ),
                            ]),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'ดูร้านค้า',
                          ),
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(width: 1, color: Colors.indigo)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.indigo),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16)),
                              textStyle: MaterialStateProperty.all(TextStyle(
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
                                    Text(
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
                                            children: [
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
                                children: <Widget>[
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
                                      children: [
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
                      Divider(
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
      ),
    );
  }
}
