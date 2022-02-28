import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  _ProductScreenState createState() => _ProductScreenState();

  static const String routeName = '/product';

  static Route route({required Product product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ProductScreen(product: product),
    );
  }
}

class _ProductScreenState extends State<ProductScreen> {
  bool isOwner = false;

  initState() {
    isOwner = FirebaseAuth.instance.currentUser?.uid == widget.product.owner;
  }

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
                        backgroundColor: MaterialStateProperty.all(
                            primaryColor.withOpacity(0.2)),
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("products")
              .doc(widget.product.id)
              .collection("reviews")
              .orderBy('dateCreated', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.requireData;
            final productRating =
                data.docs.map((m) => m['rating']!).reduce((a, b) => a + b) /
                    data.docs.length;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      child: Carousel(
                        boxFit: BoxFit.cover,
                        images: [
                          NetworkImage(widget.product.imageUrl),
                        ],
                        dotSize: 8.0,
                        dotSpacing: 25.0,
                        dotBgColor: Colors.grey[800]!.withOpacity(0.25),
                      )),
                  isOwner
                      ? Container(
                          //height: 60,
                          padding: const EdgeInsets.all(16),
                          color: primaryColor[50],
                          child: Row(
                            children: [
                              Expanded(child: Text('สินค้าของคุณ')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit_product',
                                      arguments: widget.product,
                                    );
                                  },
                                  child: const Text('แก้ไข'),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(fontSize: 16))))
                            ],
                          ))
                      : const SizedBox(),
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
                                //'กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก',
                                widget.product.name,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(children: [
                            StarRating(rating: productRating),
                            Text(productRating.toString()),
                            // const VerticalDivider(
                            //   color: Colors.grey,
                            // ),
                            //const Text('เช่าแล้ว 33 ครั้ง'),
                          ]),
                        ),
                        const Text('ราคาเช่า'),
                        const SizedBox(
                          height: 4,
                        ),
                        widget.product.pricePerDay != 0
                            ? Text(
                                '฿' +
                                    widget.product.pricePerDay.toString() +
                                    '/วัน',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              )
                            : SizedBox(),
                        widget.product.pricePerWeek != 0
                            ? Text(
                                '฿' +
                                    widget.product.pricePerWeek.toString() +
                                    '/สัปดาห์',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              )
                            : SizedBox(),
                        widget.product.pricePerMonth != 0
                            ? Text(
                                '฿' +
                                    widget.product.pricePerMonth.toString() +
                                    '/เดือน',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              )
                            : SizedBox(),
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
                        children: [
                          const Text(
                            'ค่ามัดจำ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.product.deposit,
                            style: const TextStyle(
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
                            'ที่อยู่สินค้า',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(widget.product.location),
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
                            'รายละเอียด',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.product.description,
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
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 1, color: Colors.indigo)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.indigo),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16)),
                                  textStyle:
                                      MaterialStateProperty.all(const TextStyle(
                                    fontSize: 14,
                                  )))),
                        ]),
                        Text('10 รายการสินค้า'),
                        Text('64 รายการสินค้า'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
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
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                StarRating(rating: productRating),
                                Text(
                                  productRating.toString() + '/5',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                Text(
                                  ' (' +
                                      data.docs.length.toString() +
                                      ' รีวิว)',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                //data.docs.length
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.docs.length.clamp(0, 3),
                        itemBuilder: (context, index) {
                          return ReviewCard(
                            review: Review.fromSnapshot(data.docs[index]),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                      color: Colors.white,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/review',
                                      arguments: widget.product,
                                    );
                                  },
                                  child: Text('ดูทั้งหมด'))),
                        ],
                      )),
                ],
              ),
            );
          }),
    );
  }
}
