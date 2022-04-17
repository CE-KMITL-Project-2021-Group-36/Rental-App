import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMerhods{
  getUserByUserId(String userId){
    FirebaseFirestore.instance.collection("users").doc(userId).snapshots();
  }
}