import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map> myCategories =
      List.generate(24, (index) => {"id": index, "name": "ชนิด $index", "image": "https://picsum.photos/250?image=$index"})
          .toList();

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
        shadowColor: Colors.transparent,
      ),
      body: Container(
        color: Colors.white,
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
                SizedBox(
                  width: double.infinity,
                  height: 416,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 144,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4),
                      itemCount: myCategories.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          //color: Colors.indigo,
                          child: InkWell(
                              onTap: () => {},
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 88,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            myCategories[index]['image']),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                          child: Text(
                                              myCategories[index]['name'])))
                                ],
                              )),
                        );
                      }),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
