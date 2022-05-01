import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String owner;
  final String name;
  final List<String> imageUrl;
  final String category;
  final double pricePerDay;
  final double pricePerWeek;
  final double pricePerMonth;
  final String description;
  final String deposit;
  final String location;
  final Timestamp dateCreated;
  final bool isFeature;
  final String deliveryType;

  Product({
    required this.id,
    required this.owner,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.pricePerDay,
    required this.pricePerWeek,
    required this.pricePerMonth,
    required this.description,
    required this.deposit,
    required this.location,
    required this.dateCreated,
    required this.isFeature,
    required this.deliveryType,
  });

  static Product fromSnapshot(DocumentSnapshot snapshot) {
    Product product = Product(
      id: snapshot.id,
      owner: snapshot['owner'],
      name: snapshot['name'],
      category: snapshot['category'],
      imageUrl: List.from(snapshot['imageUrl']),
      pricePerDay: snapshot['pricePerDay'].toDouble(),
      pricePerWeek: snapshot['pricePerWeek'].toDouble(),
      pricePerMonth: snapshot['pricePerMonth'].toDouble(),
      description: snapshot['description'],
      deposit: snapshot['deposit'],
      location: snapshot['location'],
      dateCreated: snapshot['dateCreated'],
      isFeature: snapshot['isFeature'],
      deliveryType: snapshot['deliveryType'],
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
