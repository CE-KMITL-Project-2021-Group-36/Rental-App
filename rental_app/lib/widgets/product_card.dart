import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final hasData = FirebaseFirestore.instance.collection("products").doc(product.id).collection("reviews").snapshots().length != 0;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: outlineColor, width: 1),
          borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product,
          );
        },
        child: SizedBox(
          width: 164,
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ink.image(
                height: 160,
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      //Star
                      
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("products")
                              .doc(product.id)
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
                            final data = snapshot.requireData;
                            var productRating = data.docs
                                    .map((m) => m['rating']!)
                                    .reduce((a, b) => a + b) /
                                data.docs.length;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  StarRating(rating: productRating),
                                  Text(
                                    '(' + data.docs.length.toString() + ')',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                            );
                          }),
                      //Price
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            displayPrice(),
                            style: const TextStyle(
                                fontSize: 16, color: primaryColor),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), //Image.asset('assets/card-sample-image-2.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  String displayPrice() {
    if (product.pricePerDay > 0) {
      return '฿' + product.pricePerDay.toString() + '/วัน';
    } else if (product.pricePerWeek > 0) {
      return '฿' + product.pricePerWeek.toString() + '/สัปดาห์';
    } else {
      return '฿' + product.pricePerMonth.toString() + '/เดือน';
    }
  }
}
