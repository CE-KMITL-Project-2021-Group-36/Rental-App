import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  //final int id;
  final String name;
  final String imageUrl;

  const Category(
    {
      //required this.id,
      required this.name,
      required this.imageUrl,
    }
  );

  static Category fromSnapshot(DocumentSnapshot snap){
    Category category = Category(name: snap['name'], imageUrl: snap['image']);
    return category;
  }
}
