import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final bool anonymous = FirebaseAuth.instance.currentUser!.isAnonymous;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('รายการที่ชอบ'),
          centerTitle: true,
        ),
        body: anonymous
            ? const Center(
                child: Text('คุณยังไม่ได้สมัครสมาชิก'),
              )
            : Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUserId)
                        .collection('favourites')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Somthing went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final data = snapshot.data;
                      return data?.size == 0
                          ? const Expanded(
                              child: Center(
                                child: Text('ไม่มีสินค้าในรายการที่ชอบ'),
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.65),
                                itemCount: data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("products")
                                          .doc(data.docs[index].id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'มีบางอย่างผิดพลาด');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        final productData = snapshot.data;
                                        return Center(
                                          child: ProductCard(
                                            product: Product.fromSnapshot(
                                                productData!),
                                          ),
                                        );
                                      });
                                },
                              ),
                            );
                    },
                  ),
                ],
              ),
      );
}
