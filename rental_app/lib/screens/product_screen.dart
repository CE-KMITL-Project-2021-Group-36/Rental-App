import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/widgets/choice_chip.dart';
import 'package:rental_app/widgets/product_slide_panel.dart';
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
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    isOwner = currentUserId == widget.product.owner;
  }

  void _slidePanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ProductSlidePanel(
          product: widget.product,
        );
      },
    );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () {
          Navigator.pushNamed(context, '/add_review',
              arguments: widget.product);
        },
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
                onPressed: () {
                  enterChatRoom(context, currentUserId, widget.product.owner);
                },
                child: Column(
                  children: const [
                    Icon(Icons.chat_bubble),
                    Text('ส่งข้อความ'),
                  ],
                ),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
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
                    const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: TextButton(
                onPressed: () {
                  _slidePanel();
                },
                child: const Text('ส่งคำขอเช่า'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
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
                images: [
                  NetworkImage(widget.product.imageUrl),
                ],
                dotSize: 0.0,
                dotSpacing: 25.0,
                dotBgColor: Colors.grey[800]!.withOpacity(0.0),
              ),
            ),
            isOwner
                ? Container(
                    //height: 60,
                    padding: const EdgeInsets.all(16),
                    color: primaryColor[50],
                    child: Row(
                      children: [
                        const Expanded(child: Text('สินค้าของคุณ')),
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
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
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
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 20,
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
                  StreamBuilder<QuerySnapshot>(
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.requireData;
                          double sum = 0;
                          data.docs.forEach((m) {
                            sum = sum + m['rating']!;
                          });
                          double avg = sum / data.docs.length;
                          bool isHasReview = sum != 0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              children: [
                                StarRating(rating: avg),
                                isHasReview
                                    ? Text(
                                        avg.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          //color: primaryColor,
                                        ),
                                      )
                                    : const Text(
                                        'ยังไม่มีรีวิว',
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                // Text(
                                //   ' (' + data.docs.length.toString() + ' รีวิว)',
                                //   style: const TextStyle(color: Colors.grey),
                                // ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                  const Text(
                    'ราคาเช่า',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  widget.product.pricePerDay != 0
                      ? Text(
                          '฿' +
                              currencyFormat(widget.product.pricePerDay) +
                              '/วัน',
                          style: const TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                          ),
                        )
                      : const SizedBox(),
                  widget.product.pricePerWeek != 0
                      ? Text(
                          '฿' +
                              currencyFormat(widget.product.pricePerWeek) +
                              '/สัปดาห์',
                          style: const TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                          ),
                        )
                      : const SizedBox(),
                  widget.product.pricePerMonth != 0
                      ? Text(
                          '฿' +
                              currencyFormat(widget.product.pricePerMonth) +
                              '/เดือน',
                          style: const TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                          ),
                        )
                      : const SizedBox(),
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
                    widget.product.deposit.replaceAll("\\n", "\n"),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
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
                children: [
                  const Text(
                    'ที่อยู่สินค้า',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.location,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
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
                  children: [
                    const Text(
                      'รายละเอียด',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description.replaceAll("\\n", "\n"),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
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
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/images/shop_profile.png'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.storefront,
                                    color: primaryColor, size: 16),
                                Text(' RentKlong',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.location_on,
                                    color: primaryColor, size: 16),
                                Text('บางนา, กรุงเทพมหานคร')
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(' มี 3 สินค้าให้เช่า'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Text(
                              'ไปที่ร้าน',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,
                                color: primaryColor, size: 24),
                          ],
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(primaryColor),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16)),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
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
                if (snapshot.hasData) {
                  final data = snapshot.requireData;
                  double sum = 0;
                  data.docs.forEach((m) {
                    sum = sum + m['rating']!;
                  });
                  double avg = sum / data.docs.length;
                  bool isHasReview = sum != 0;
                  return Column(
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
                            isHasReview
                                ? Row(
                                    children: [
                                      StarRating(rating: avg),
                                      Text(
                                        avg.toStringAsFixed(1) + '/5',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                      Text(
                                        ' (' +
                                            data.docs.length.toString() +
                                            ' รีวิว)',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      //data.docs.length
                                    ],
                                  )
                                : Row(
                                    children: const [
                                      Text(
                                        'ยังไม่มีรีวิว',
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
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
                      data.docs.length > 3
                          ? Container(
                              color: Colors.white,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/review',
                                          arguments: widget.product,
                                        );
                                      },
                                      child: const Text('ดูทั้งหมด'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 8),
                    ],
                  );
                }
                return const StarRating(rating: -1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
