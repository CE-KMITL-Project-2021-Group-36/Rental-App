import 'package:cloud_firestore/cloud_firestore.dart';

class Contract {
    final String id;
  final String productId;
  final String renterId;
  final String ownerId;
  final Timestamp startDate;
  final Timestamp endDate;
  final double deposit;
  final double rentalPrice;
  final String renterStatus;
  final String ownerStatus;
  final List<String> imageUrls;

  const Contract({
    required this.id,
    required this.productId,
    required this.renterId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.deposit,
    required this.rentalPrice,
    required this.renterStatus,
    required this.ownerStatus,
    required this.imageUrls,
  });

  static Contract fromSnapshot(DocumentSnapshot snapshot) {
    Contract contract = Contract(
      id: snapshot.id,
      productId: snapshot['productId'],
      renterId: snapshot['renterId'],
      ownerId: snapshot['ownerId'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      deposit: snapshot['deposit'].toDouble(),
      rentalPrice: snapshot['rentalPrice'].toDouble(),
      renterStatus: snapshot['renterStatus'],
      ownerStatus: snapshot['ownerStatus'],
      imageUrls: List.from(snapshot['imageUrls']),
    );
    return contract;
  }
}