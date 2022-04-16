import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

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

  //final _userId = FirebaseAuth.instance.currentUser?.uid;
  final _userId = 'Yew';
  int _rating = 1;
  String _text = '';

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
            TextButton(
              child: const Text('บันทึก'),
              onPressed: () async {
                await products
                    .doc(widget.product.id)
                    .collection("reviews")
                    .doc(_userId)
                    .set({
                      'userId': _userId,
                      'rating': _rating,
                      'text': _text,
                      'dateCreated': DateTime.now(),
                    })
                    .then((value) => debugPrint('Review Added'))
                    .catchError(
                        (error) => debugPrint('Failed to add review: $error'));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('อัพเดทรีวิว'),
                ));
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                primary: Colors.white,
                backgroundColor: primaryColor,
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
