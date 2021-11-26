import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map> myCategories = List.generate(
      24,
      (index) => {
            "id": index,
            "name": "ชนิด $index",
            "image": "https://picsum.photos/250?image=$index"
          }).toList();

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
          elevation: 2,
          //shadowColor: Colors.transparent,
        ),
        body: Container(
          //color: Colors.red,
          height: double.infinity,
          width: double.infinity,
          //margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextFormField(
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
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "ประเภทสินค้าเช่า",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "ดูทั้งหมด",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ]),
              ),
              SingleChildScrollView(
                //color: Colors.red,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    _buildCategoryProduct("เสื้อผ้าผู้ชาย",
                        "https://assets.ajio.com/medias/sys_master/root/20210403/OjjF/6068dc44aeb269a9e33a52ba/-288Wx360H-462103975-pink-MODEL.jpg"),
                    _buildCategoryProduct("เสื้อผ้าผู้หญิง",
                        "https://image.freepik.com/free-photo/stunning-curly-female-model-jumping-purple-indoor-portrait-slim-girl-bright-yellow-dress_197531-10836.jpg"),
                    _buildCategoryProduct("กล้อง และอุปกรณ์", "https://image.freepik.com/free-photo/photographer-snapping-with-analog-camera_53876-105703.jpg"),
                    _buildCategoryProduct("ตั้งแคมป์", "https://image.freepik.com/free-photo/group-man-woman-enjoy-camping-picnic-barbecue-lake-with-tents-background-young-mixed-race-asian-woman-man-young-people-s-hands-toasting-cheering-bottles-beer_1253-1041.jpg"),
                    _buildCategoryProduct("หนังสือ", "https://image.freepik.com/free-photo/book-library-with-open-textbook_1150-5924.jpg"),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "สินค้าน่าสนใจ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "ดูทั้งหมด",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget _buildCategoryProduct(String name, String imageUrl) {
    return Container(
      //color: Colors.blue,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageUrl),
          ),
          Container(
              //color: Colors.indigo,
              height: 40,
              width: 80,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ))
        ],
      ),
    );
  }
}
