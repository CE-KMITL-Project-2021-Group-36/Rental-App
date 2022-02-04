import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class CatalogScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.indigo),
          backgroundColor: Colors.white,
          title: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'ค้นหา ใน' + category.name,
                  contentPadding: const EdgeInsets.all(8)),
            ),
          )),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where('category', isEqualTo: category.name)
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.65),
                        itemCount: data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child: ProductCard(
                                  product:
                                      Product.fromSnapshot(data.docs[index])));
                        }));
              }),
        ],
      ),
    );
  }
}
