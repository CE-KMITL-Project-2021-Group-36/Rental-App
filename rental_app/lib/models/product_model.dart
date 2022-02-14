import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String owner;
  final String name;
  final String imageUrl;
  final String category;
  final num pricePerDay;
  final num pricePerWeek;
  final num pricePerMonth;

  Product({
    required this.owner,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.pricePerDay,
    required this.pricePerWeek,
    required this.pricePerMonth,
  });

  static Product fromSnapshot(DocumentSnapshot snapshot) {
    Product product = Product(
      owner: snapshot['owner'],
      name: snapshot['name'],
      category: snapshot['category'],
      imageUrl: snapshot['imageUrl'],
      pricePerDay: snapshot['pricePerDay'],
      pricePerWeek: snapshot['pricePerWeek'],
      pricePerMonth: snapshot['pricePerMonth'],
    );
    return product;
  }

  // static List<Product> products = [
  //   Product(
  //     owner: '01',
  //     name: "กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก",
  //     category: "อุปกรณ์ถ่ายภาพ",
  //     pricePerDay: 100,
  //     imageUrl:
  //         "https://www.ec-mall.com/wp-content/uploads/2018/03/eos-1500d_02-1.jpg",
  //   ),
  //   Product(
  //     owner: '01',
  //     name: "กล้อง Instax กล้องฟิล์ม",
  //     category: "อุปกรณ์ถ่ายภาพ",
  //     pricePerDay: 600,
  //     imageUrl:
  //         "https://m.media-amazon.com/images/I/71HmLp20ovL._AC_SL1500_.jpg",
  //   ),
  //   Product(
  //     owner: '01',
  //     name: "เต้นท์แคมป์ปิง นอนได้ 2-3 คน กางง่ายมากกก",
  //     category: "ตั้งแคมป์",
  //     pricePerDay: 100,
  //     imageUrl:
  //         "https://m.media-amazon.com/images/I/61XFCgVG1TL._AC_SL1500_.jpg",
  //   ),
  //   Product(
  //     owner: '02',
  //     name: "ชุดสูทชาย ทรงเข้ารูป สีดำ รอบอก 44 ",
  //     category: "เสื้อผ้าผู้ชาย",
  //     pricePerDay: 500,
  //     imageUrl:
  //         "https://image.makewebeasy.net/makeweb/0/Bah9vh8Ox/LazadaSuits2017/Hi_class_Suit_%E0%B8%8A%E0%B8%B8%E0%B8%94%E0%B8%AA%E0%B8%B9%E0%B8%97_%E0%B8%8A%E0%B8%B2%E0%B8%A2_%E0%B8%97%E0%B8%A3%E0%B8%87%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A3%E0%B8%B9%E0%B8%9B_Slim_%E0%B8%AA%E0%B8%B5%E0%B8%94%E0%B8%B3_black_.jpg",
  //   ),
  //   Product(
  //     owner: '02',
  //     name: "Gucci belt เข็มขัดสีดำ Gucci ของแท้",
  //     category: "เสื้อผ้าผู้ชาย",
  //     pricePerDay: 850,
  //     imageUrl:
  //         "https://img.mytheresa.com/1088/1088/66/jpeg/catalog/product/bf/P00398351.jpg",
  //   ),
  // ];
}
