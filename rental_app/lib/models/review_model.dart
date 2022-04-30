import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String text;
  final double rating;
  final Timestamp dateCreated;
  final List<String> imageUrl;

  Review({
    required this.id,
    required this.userId,
    required this.text,
    required this.rating,
    required this.dateCreated,
    required this.imageUrl,
  });

  static Review fromSnapshot(DocumentSnapshot snapshot) {
    Review review = Review(
      id: snapshot.id,
      userId: snapshot['userId'],
      text: snapshot['text'],
      rating: snapshot['rating'].toDouble(),
      imageUrl: List.from(snapshot['imageUrl']),
      dateCreated: snapshot['dateCreated'],
    );
    return review;
  }
}
