class Product {
  final String name;
  final String price;
  final String imageUrl;
  final String category;

  Product(
      {required this.name,
      required this.category,
      required this.price,
      required this.imageUrl});

  static List<Product> products = [
    Product(
      name: "กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก",
      category: "อุปกรณ์ถ่ายภาพ",
      price: "฿100 /ชม.\n฿700 /วัน.\n฿4500 /สัปดาห์.",
      imageUrl:
          "https://www.ec-mall.com/wp-content/uploads/2018/03/eos-1500d_02-1.jpg",
    ),
    Product(
      name: "กล้อง Instax กล้องฟิล์ม",
      category: "อุปกรณ์ถ่ายภาพ",
      price: "฿600 /วัน.",
      imageUrl:
          "https://m.media-amazon.com/images/I/71HmLp20ovL._AC_SL1500_.jpg",
    ),
    Product(
      name: "เต้นท์แคมป์ปิง นอนได้ 2-3 คน กางง่ายมากกก",
      category: "ตั้งแคมป์",
      price: "฿100 /วัน.",
      imageUrl:
          "https://m.media-amazon.com/images/I/61XFCgVG1TL._AC_SL1500_.jpg",
    ),
    Product(
      name: "ชุดสูทชาย ทรงเข้ารูป สีดำ รอบอก 44 ",
      category: "เสื้อผ้าผู้ชาย",
      price: "฿500 /วัน.\n฿2000 /สัปดาห์.",
      imageUrl:
          "https://image.makewebeasy.net/makeweb/0/Bah9vh8Ox/LazadaSuits2017/Hi_class_Suit_%E0%B8%8A%E0%B8%B8%E0%B8%94%E0%B8%AA%E0%B8%B9%E0%B8%97_%E0%B8%8A%E0%B8%B2%E0%B8%A2_%E0%B8%97%E0%B8%A3%E0%B8%87%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A3%E0%B8%B9%E0%B8%9B_Slim_%E0%B8%AA%E0%B8%B5%E0%B8%94%E0%B8%B3_black_.jpg",
    ),
    Product(
      name: "Gucci belt เข็มขัดสีดำ Gucci ของแท้",
      category: "เสื้อผ้าผู้ชาย",
      price: "฿850 /วัน.",
      imageUrl:
          "https://img.mytheresa.com/1088/1088/66/jpeg/catalog/product/bf/P00398351.jpg",
    ),
  ];
}
