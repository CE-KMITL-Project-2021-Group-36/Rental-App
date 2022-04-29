import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
  static const String routeName = '/product_management';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ProductManagementScreen(),
    );
  }
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final String? _owner = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("products")
          .where('owner', isEqualTo: _owner)
          .orderBy('dateCreated', descending: true)
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
        final data = snapshot.requireData;
        return Scaffold(
          appBar: AppBar(
            title: Text('สินค้าทั้งหมด(${data.docs.length})'),
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.65),
                  itemCount: data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: ProductCard(
                        product: Product.fromSnapshot(data.docs[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
