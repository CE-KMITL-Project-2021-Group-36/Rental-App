import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key, required this.product}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();

  static const String routeName = '/add_review';

  static Route route({required Product product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => AddReviewScreen(product: product),
    );
  }

  final Product product;
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  final _userId = FirebaseAuth.instance.currentUser!.uid;
  int _rating = 0;
  String _text = '';

  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  List<File> _image = [];
  List _imageUrl = [];
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  void initState() {
    super.initState();
    _setDataInit();
  }

  _setDataInit() async {
    final snapshot = await products
        .doc(widget.product.id)
        .collection("reviews")
        .doc(_userId)
        .get();
    if (snapshot.exists) {
      await products
          .doc(widget.product.id)
          .collection("reviews")
          .doc(_userId)
          .get()
          .then((doc) {
        setState(() {
          _rating = doc.data()!['rating'];
          _text = doc.data()!['text'];
        });
      });
    }
  }

  chooseImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('กล้องถ่ายรูป'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('เลือกจากคลัง'),
              onTap: () async {
                Navigator.of(context).pop();
                pickImage(ImageSource.gallery);
              },
            )
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(source: source);
    await uploadFile(File(pickedFile!.path));
  }

  Future uploadFile(img) async {
    ref = storage.ref().child(
        'review_images/${widget.product.id}/${FirebaseAuth.instance.currentUser?.uid}/${path.basename(img.path)}');
    await ref.putFile(img).whenComplete(() async {
      await ref.getDownloadURL().then((value) async {
        await products
            .doc(widget.product.id)
            .collection("reviews")
            .doc(_userId)
            .update({
          'imageUrl': FieldValue.arrayUnion([value]),
        });
      });
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("ยกเลิก"),
      style: TextButton.styleFrom(
          primary: errorColor,
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ใช่ ลบรีวิว"),
      style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: errorColor,
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () async {
        final ref = products.doc(widget.product.id).collection('reviews');
        if (ref.doc(_userId) != null) {
          ref.doc(_userId).delete();
        }
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ลบรีวิวนี้แล้ว'),
        ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ลบรีวิว?"),
      content: const Text("การลบนี้จะลบรีวิวนี้โดยถาวร"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รีวิวของคุณ"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ให้คะแนน',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                SetRating((rating) {
                  setState(
                    () {
                      _rating = rating;
                    },
                  );
                }, _rating, 5),
                const SizedBox(width: 8),
                Text(
                  _rating.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'ข้อความรีวิว',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(height: 4),
            TextFormField(
              key: Key(_text),
              initialValue: _text,
              onChanged: (value) {
                _text = value;
              },
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'ใส่ข้อความรีวิว',
                alignLabelWithHint: true,
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'รูปภาพ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot>(
                stream: products
                    .doc(widget.product.id)
                    .collection("reviews")
                    .doc(_userId)
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
                  final data = snapshot.data;
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data!['imageUrl'].length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? InkWell(
                              splashColor: primaryColor,
                              onTap: data['imageUrl'].length == 5 ? null : (() {
                                !uploading ? chooseImage() : null;
                              }),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: data['imageUrl'].length == 5 ? Colors.grey[200] :primaryColor[50],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: Icon(Icons.add_rounded,
                                    color: data['imageUrl'].length == 5 ? Colors.grey : primaryColor, size: 60),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image: NetworkImage(
                                        data['imageUrl'][index - 1],
                                      ),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: errorColor,
                                  ),
                                  tooltip: 'ลบรูปนี้',
                                  onPressed: () async {
                                    await products
                                        .doc(widget.product.id)
                                        .collection("reviews")
                                        .doc(_userId)
                                        .update({
                                      'imageUrl': FieldValue.arrayRemove(
                                          [data['imageUrl'][index - 1]]),
                                    });
                                  },
                                ),
                              ],
                            );
                    },
                  );
                }),
            const SizedBox(height: 16),
            const Expanded(child: SizedBox()),
            TextButton(
              child: const Text('บันทึกรีวิว'),
              onPressed: _rating == 0
                  ? null
                  : () async {
                      await products
                          .doc(widget.product.id)
                          .collection("reviews")
                          .doc(_userId)
                          .update({
                            'userId': _userId,
                            'rating': _rating,
                            'text': _text,
                            'dateCreated': DateTime.now(),
                          })
                          .then((value) => debugPrint('Review Added'))
                          .catchError((error) =>
                              debugPrint('Failed to add review: $error'));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('อัพเดทรีวิว'),
                      ));
                    },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                primary: Colors.white,
                backgroundColor: _rating == 0 ? primaryColor[50] : primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
