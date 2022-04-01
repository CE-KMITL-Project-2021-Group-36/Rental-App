import 'package:cloud_firestore/cloud_firestore.dart';

class Contract {
  final String productId;
  final String renterId;
  final Timestamp startDate;
  final Timestamp endDate;
  final double deposit;
  final double rentalPrice;
  final String status;
  final List<String> imageUrls;

  const Contract({
    required this.productId,
    required this.renterId,
    required this.startDate,
    required this.endDate,
    required this.deposit,
    required this.rentalPrice,
    required this.status,
    required this.imageUrls,
  });

  static Contract fromSnapshot(DocumentSnapshot snapshot) {
    Contract contract = Contract(
      productId: snapshot['productId'],
      renterId: snapshot['renterId'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      deposit: snapshot['deposit'].toDouble(),
      rentalPrice: snapshot['rentalPrice'].toDouble(),
      status: snapshot['status'],
      imageUrls: List.from(snapshot['imageUrls']),
    );
    return contract;
  }
}
