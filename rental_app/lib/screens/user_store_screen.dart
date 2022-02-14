import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class UserStoreScreen extends StatefulWidget {
  const UserStoreScreen({ Key? key }) : super(key: key);

  @override
  _UserStoreScreenState createState() => _UserStoreScreenState();

  static const String routeName = '/user_store';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const UserStoreScreen(),
    );
  }
  
}

final store_owner = FirebaseAuth.instance.currentUser?.uid;

class _UserStoreScreenState extends State<UserStoreScreen> {

  var itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ร้านค้าของคุณ")),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {Navigator.pushNamed(context, '/add_product');},
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('สินค้าทั้งหมด ($itemCount)', style: const TextStyle(color: primaryColor),),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where('owner', isEqualTo: store_owner)
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
                itemCount = data.docs.length;
                return Expanded(
                    child: GridView.builder(
                        
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.65),
                        itemCount: itemCount,
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