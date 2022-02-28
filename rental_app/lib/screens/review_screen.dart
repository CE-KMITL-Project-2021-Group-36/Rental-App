import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ReviewScreen extends StatefulWidget {
  final Product product;

  const ReviewScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();

  static const String routeName = '/review';

  static Route route({required Product product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ReviewScreen(product: product),
    );
  }
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.product.id);
    return Scaffold(
      appBar: AppBar(title: Text('รีวิว')),
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
          var productRating =
              data.docs.map((m) => m['rating']!).reduce((a, b) => a + b) /
                  data.docs.length;
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
                    Row(
                      children: [
                        StarRating(rating: productRating),
                        Text(
                          productRating.toString() + '/5',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        Text(
                          ' (' + data.docs.length.toString() + ' รีวิว)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        //data.docs.length
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  return ReviewCard(
                    review: Review.fromSnapshot(data.docs[index]),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
