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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "หน้าแรก",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: surfaceColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "ค้นหา",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
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
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, childAspectRatio: 0.9),
                      itemCount: Category.categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryCard(
                            category: Category.categories[index]);
                      }),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "สินค้าน่าสนใจ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/search');
                        },
                        child: const Text(
                          "ดูทั้งหมด",
                          style: TextStyle(fontSize: 12, color: primaryColor),
                        ),
                      )
                    ]),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: Product.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: Product.products[index]);
                    }
                  )
                ),
                const SizedBox(height: 60)
              ],
            ),
          ),
        ));
  }
}
