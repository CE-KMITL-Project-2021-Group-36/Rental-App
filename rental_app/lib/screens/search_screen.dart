import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
  static const String routeName = '/search';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SearchScreen(),
    );
  }
}

class _SearchScreenState extends State<SearchScreen> {
  List products = [];
  String query = '';
  String searchtxt = '';

  @override
  void initState() {
    super.initState();
  }

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
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'ค้นหา',
                  contentPadding: EdgeInsets.all(8)),
              onChanged: (text) {
                //searchProduct(text);
                searchtxt = text;
                setState(() {});
              },
            ),
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where("name", isGreaterThanOrEqualTo: searchtxt)
                  .where("name", isLessThanOrEqualTo: "$searchtxt\uf7ff")
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
                          product: Product.fromSnapshot(data.docs[index]),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  void searchProduct(String query) {
    products = products.where((product) {
      final nameLower = product.name.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.products = products;
    });
  }
}
