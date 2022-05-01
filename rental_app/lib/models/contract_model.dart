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
  final List<String> renterAttachments;
  final String renterPickupVideo;
  final String renterReturnVideo;
  final String ownerDeliveryVideo;
  final String ownerPickupVideo;
  final String deliveryType;
  final String renterAddressName;
  final String renterAddressPhone;
  final String renterAddress;

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
    required this.renterAttachments,
    required this.renterPickupVideo,
    required this.renterReturnVideo,
    required this.ownerDeliveryVideo,
    required this.ownerPickupVideo,
    required this.deliveryType,
    required this.renterAddressName,
    required this.renterAddressPhone,
    required this.renterAddress,
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
      renterAttachments: List.from(snapshot['renterAttachments']),
      renterPickupVideo: snapshot['renterPickupVideo'],
      renterReturnVideo: snapshot['renterReturnVideo'],
      ownerDeliveryVideo: snapshot['ownerDeliveryVideo'],
      ownerPickupVideo: snapshot['ownerPickupVideo'],
      deliveryType: snapshot['deliveryType'],
      renterAddressName: snapshot['renterAddressName'],
      renterAddressPhone: snapshot['renterAddressPhone'],
      renterAddress: snapshot['renterAddress'],
    );
    return contract;
  }
}
