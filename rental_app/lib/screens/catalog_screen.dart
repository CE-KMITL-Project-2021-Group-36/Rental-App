import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key, required this.category}) : super(key: key);

  static const String routeName = '/catalog';

  static Route route({required Category category}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => CatalogScreen(category: category),
    );
  }

  final Category category;

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String query = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where('category', isEqualTo: widget.category.name)
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
              return Expanded(
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
              );
            },
          ),
        ],
      ),
    );
  }
}
