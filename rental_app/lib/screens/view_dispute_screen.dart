import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class ViewDisputeScreen extends StatefulWidget {
  const ViewDisputeScreen({Key? key, required this.contract}) : super(key: key);

  @override
  State<ViewDisputeScreen> createState() => _ViewDisputeScreenState();
  final Contract contract;
}

class _ViewDisputeScreenState extends State<ViewDisputeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ข้อพิพาท")),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('disputes')
              .doc(widget.contract.id)
              .snapshots(),
          builder: (context, snapshot) {
            final dispute = snapshot.data;
            return dispute == null
                ? Container()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'หมายเลขสัญญาเช่า:' + widget.contract.id,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'หัวข้อ/สาเหตุ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dispute['title'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'รายละเอียด',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dispute['detail'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'ภาพหลักฐานเพิ่มเติม',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dispute['imageUrls'].length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Ink.image(
                                  image:
                                      NetworkImage(dispute['imageUrls'][index]),
                                  fit: BoxFit.cover,
                                  child: InkWell(
                                    onTap: () {
                                      //Go to ImageView
                                    },
                                  ),
                                );
                              }),
                          const SizedBox(height: 32),
                          Text('สร้างเมื่อ '+ DateFormat('dd-MM-yyyy').format(dispute['dateCreated'].toDate()))
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
