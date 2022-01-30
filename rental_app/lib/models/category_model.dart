import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String imageUrl;

  const Category({
    required this.name,
    required this.imageUrl,
  });

  static List<Category> categories = const [
    Category(
      name: "เสื้อผ้าผู้ชาย",
      imageUrl:
          "https://assets.ajio.com/medias/sys_master/root/20210403/OjjF/6068dc44aeb269a9e33a52ba/-288Wx360H-462103975-pink-MODEL.jpg",
    ),
    Category(
      name: "เสื้อผ้าผู้หญิง",
      imageUrl:
          "https://image.freepik.com/free-photo/stunning-curly-female-model-jumping-purple-indoor-portrait-slim-girl-bright-yellow-dress_197531-10836.jpg",
    ),
    Category(
      name: "อุปกรณ์ถ่ายภาพ",
      imageUrl:
          "https://image.freepik.com/free-photo/photographer-snapping-with-analog-camera_53876-105703.jpg",
    ),
    Category(
      name: "ตั้งแคมป์",
      imageUrl:
          "https://image.freepik.com/free-photo/group-man-woman-enjoy-camping-picnic-barbecue-lake-with-tents-background-young-mixed-race-asian-woman-man-young-people-s-hands-toasting-cheering-bottles-beer_1253-1041.jpg",
    ),
    Category(
      name: "หนังสือ",
      imageUrl:
          "https://image.freepik.com/free-photo/book-library-with-open-textbook_1150-5924.jpg",
    ),
    Category(
      name: "อุปรณ์กีฬา",
      imageUrl:
          "https://www.smeleader.com/wp-content/uploads/2019/06/%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%82%E0%B8%B2%E0%B8%A2%E0%B8%AD%E0%B8%B8%E0%B8%9B%E0%B8%81%E0%B8%A3%E0%B8%93%E0%B9%8C%E0%B8%81%E0%B8%B5%E0%B8%AC%E0%B8%B2-660x330.jpg",
    ),
    Category(
      name: "อุปกรณ์อิเล็กทรอนิกส์",
      imageUrl:
          "https://blessingstelecom.com/img/developerimg/choco_blessingstelecom_20200113100659_db/mebase/CustomSectionStyle/Images/original_200219061202_5e4cd1b2c5eb3.jpg",
    ),
    Category(
      name: "อื่นๆ",
      imageUrl:
          "https://apisproductions.com/wp-content/uploads/2020/02/three-dots.png",
    ),
  ];
}
