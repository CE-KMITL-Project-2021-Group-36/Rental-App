import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/widgets/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomeScreen(),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          //backgroundColor: Colors.green,
          onPressed: () {
            //Navigator.pushNamed(context, '/add_product');
            sendPushNotification('title', 'text', 'f0CxIdkCQt6Vg3laYY516j:APA91bEpyyZ5syhdn3WOtRQ9VrVkYlPx6JrYzY1Ph1p7RWC8uO8nVmp3iB-vrdCcEpwAVyO2D-dxv0ajK7l0Cc5Gzu70-qiN50pc2XLuosCTYlqdOMDYVn42ht9jrSA6cQEFug2JaZr1');
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Rental App",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: surfaceColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "ประเภทสินค้า",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("categories")
                              .orderBy('id')
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
                            return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 0.9),
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  return CategoryCard(
                                      category: Category.fromSnapshot(
                                          data.docs[index]));
                                });
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: primaryColor[50],
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "สินค้าน่าสนใจ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              //Navigator.pushNamed(context, '/search');
                            },
                            child: const Text(
                              "ดูทั้งหมด",
                              style:
                                  TextStyle(fontSize: 14, color: primaryColor),
                            ),
                          )
                        ]),
                    SizedBox(
                      height: 280,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("products")
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
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data.docs.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  ProductCard(
                                    product:
                                        Product.fromSnapshot(data.docs[index]),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 16)
            ],
          ),
        ));
  }
}
