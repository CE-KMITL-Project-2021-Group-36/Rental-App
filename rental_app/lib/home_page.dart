import 'package:flutter/material.dart';
import './category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                // padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () => {},
                        style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24.0),
                                        side: BorderSide(color: Colors.grey)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("ค้นหาสินค้า",
                                style: TextStyle(color: Colors.grey)),
                            Icon(Icons.search),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("หมวดหมู่แนะนำ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SafeArea(
                        child: SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: GridView(
                        padding: EdgeInsets.all(8),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            childAspectRatio: 4 / 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        children: [
                          CategoryCard(),
                          CategoryCard(),
                          CategoryCard(),
                          CategoryCard(),
                          CategoryCard(),
                          CategoryCard(),
                          CategoryCard(),
                          
                        ],
                      ),
                    )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
