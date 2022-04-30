import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/view_contract_screen.dart';
import 'package:rental_app/screens/upload_evidence_screen.dart';

import 'owner_contract_addition.dart';
import 'renter_contract_addition.dart';

class ContractCard extends StatelessWidget {
  const ContractCard({
    Key? key,
    required this.contract,
    required this.userType,
  }) : super(key: key);

  final Contract contract;
  final String userType;

  @override
  Widget build(BuildContext context) {
    DateTime startDate = contract.startDate.toDate();
    DateTime endDate = contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    final duration = endDate.difference(startDate).inDays + 1;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .doc(contract.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final product = snapshot.data;
          return product != null
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border.all(
                      color: outlineColor,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox.fromSize(
                              child: Image.network(
                                product['imageUrl'][0],
                                fit: BoxFit.cover,
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'เช่าวันที่ $formattedStartDate ถึง $formattedEndDate',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'ระยะเวลา $duration วัน',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(thickness: 0.6, height: 32),
                      userType == 'renter'
                          ? renterContractAddition(context, contract, Product.fromSnapshot(product), userType)
                          : ownerContractAddition(context, contract, Product.fromSnapshot(product), userType),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
