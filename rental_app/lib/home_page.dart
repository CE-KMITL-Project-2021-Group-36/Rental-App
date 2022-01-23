import 'package:flutter/material.dart';
import 'package:rental_app/product_detail.dart';
import 'package:rental_app/search_page.dart';

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
          elevation: 2,
          //shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
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
                        style: TextStyle(fontSize: 12, color: Colors.indigo),
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
                    _buildCategoryProduct("กล้อง และอุปกรณ์",
                        "https://image.freepik.com/free-photo/photographer-snapping-with-analog-camera_53876-105703.jpg"),
                    _buildCategoryProduct("ตั้งแคมป์",
                        "https://image.freepik.com/free-photo/group-man-woman-enjoy-camping-picnic-barbecue-lake-with-tents-background-young-mixed-race-asian-woman-man-young-people-s-hands-toasting-cheering-bottles-beer_1253-1041.jpg"),
                    _buildCategoryProduct("หนังสือ",
                        "https://image.freepik.com/free-photo/book-library-with-open-textbook_1150-5924.jpg"),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สินค้าน่าสนใจ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GridSearchScreen()),
                          );
                        },
                        child: Text(
                          "ดูทั้งหมด",
                          style: TextStyle(fontSize: 12, color: Colors.indigo),
                        ),
                        style: TextButton.styleFrom(),
                      )
                    ]),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildItemCard(
                        'กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก',
                        '฿100 /ชม.\n฿700 /วัน.\n฿4500 /สัปดาห์.',
                        'https://www.ec-mall.com/wp-content/uploads/2018/03/eos-1500d_02-1.jpg'),
                    _buildItemCard('กล้อง Instax กล้องฟิล์ม', '฿600 /วัน.',
                        'https://m.media-amazon.com/images/I/71HmLp20ovL._AC_SL1500_.jpg'),
                  ],
                ),
              )
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

  Widget _buildItemCard(String name, String price, String imageUrl) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductDetail()),
          );
        },
        child: Container(
          width: 164,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 164,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      name,
                      //'กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก',
                      style: TextStyle(
                        fontSize: 12,
                        //fontStyle: FontStylefontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        Icon(Icons.star, color: Colors.yellow[600], size: 16),
                        Icon(Icons.star, color: Colors.yellow[600], size: 16),
                        Icon(Icons.star, color: Colors.yellow[600], size: 16),
                        Icon(Icons.star, color: Colors.yellow[600], size: 16),
                        Icon(Icons.star, color: Colors.yellow[600], size: 16),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        //'฿100 /ชม.\n฿700 /วัน.\n฿4500 /สัปดาห์.\n',
                        price,
                        style: TextStyle(fontSize: 12, color: Colors.indigo
                            //fontStyle: FontStylefontWeight: FontWeight.bold,
                            ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              //Image.asset('assets/card-sample-image-2.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
