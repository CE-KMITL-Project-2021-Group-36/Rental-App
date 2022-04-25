import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
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
        backgroundColor: surfaceColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/search');
                          },
                          child: Row(
                            children: const [
                              Text(
                                'ค้นหาสินค้า',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Icon(Icons.search),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: primaryColor.withOpacity(0.2),
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.circular(32), // <-- Radius
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
                                      crossAxisCount: 4, childAspectRatio: 0.9),
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                  category: Category.fromSnapshot(
                                    data.docs[index],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  color: primaryColor[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "สินค้าน่าสนใจ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("products")
                              .where('isFeature', isEqualTo: true)
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
                                      product: Product.fromSnapshot(
                                        data.docs[index],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
