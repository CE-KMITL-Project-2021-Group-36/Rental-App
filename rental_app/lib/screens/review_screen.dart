import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  CollectionReference products =
      FirebaseFirestore.instance.collection("products");

  final userId = FirebaseAuth.instance.currentUser?.uid;

  //QuerySnapshot eventsQuery = products.doc(product.id).collection("reviews").where('userId', isEqualTo: 'Yew').isExists();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รีวิว')),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () {
          Navigator.pushNamed(context, '/add_review',
              arguments: widget.product);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products
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
            return SingleChildScrollView(
              child: Column(
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
                            StarRating(rating: avg),
                            Text(
                              avg.toStringAsFixed(1) + '/5',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
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
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return ReviewCard(
                        review: Review.fromSnapshot(data.docs[index]),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
