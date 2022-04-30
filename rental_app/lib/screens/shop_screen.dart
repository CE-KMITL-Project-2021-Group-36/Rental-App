import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({Key? key, required this.ownerId}) : super(key: key);

  final String ownerId;

  static const String routeName = '/shop';

  static Route route({required String ownerId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ShopScreen(ownerId: ownerId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(ownerId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ข้อมูลผิดพลาด");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("ไม่พบข้อมูล");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final String shopName = data['shop']['shopName'];
            final String shopDetail = data['shop']['shopDetail'];
            final String userName = data['shop']['userName'];
            final String phone = data['shop']['phone'];
            final String address = data['shop']['address'];
            final String avatarUrl = data['avatarUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4';

            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBanner(avatarUrl, shopName, context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                        child: Text(shopDetail),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.place),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        phone,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(address),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        products.where('owner', isEqualTo: ownerId).snapshots(),
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
                          physics: const BouncingScrollPhysics(),
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
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _buildTopBanner(avatarUrl, shopName, context) {
    return Stack(
      children: [
        Container(
          height: 175,
          color: primaryColor,
        ),
        Positioned(
          bottom: 15,
          left: 20,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              avatarUrl,
            ),
          ),
        ),
        Positioned(
          bottom: 32,
          left: 95,
          child: Row(
            children: [
              const Icon(
                Icons.storefront,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                shopName,
                style: const TextStyle(
                  color: primaryLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: 16,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Theme.of(context).platform == TargetPlatform.android
                  ? const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: Colors.white,
                    )),
        ),
      ],
    );
  }
}
