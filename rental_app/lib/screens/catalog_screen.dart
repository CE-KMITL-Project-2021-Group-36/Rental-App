import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
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
    final List<Product> categoryProducts = Product.products.where((product) => product.category == category.name).toList();
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
          Expanded(
            child: GridView.builder(
                //physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.65),
                itemCount: categoryProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                      child: ProductCard(product: categoryProducts[index]));
                }),
          ),
        ],
      ),
    );
  }
}