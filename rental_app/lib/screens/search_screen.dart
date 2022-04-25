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
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
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
              query = text;
              setState(() {});
            },
          ),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where("name", isGreaterThanOrEqualTo: query)
                .where("name", isLessThanOrEqualTo: "$query\uf8ff")
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
