import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class DisplayProducts extends StatefulWidget {
  const DisplayProducts({Key? key}) : super(key: key);

  @override
  _DisplayProductsState createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  final Stream<QuerySnapshot> products =
      FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Firestore'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Read Data from Clound Firestore',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Container(
                  height: 300,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: products,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return const Text('Somthing went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading');
                      }
                      final data = snapshot.requireData;

                      return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '-\tProduct: ${data.docs[index]['name']}\n\t\tPrice: ฿${data.docs[index]['pricePerDay']}/day'),
                              Container(
                                width: 100,
                                height: 100,
                                color: Palette.bluePurple[50],
                                child: Image.network(
                                  data.docs[index]['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Center(child: Icon(Icons.error_outline, color: Colors.white, size: 40));
                                  },
                                ),
                              ),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                color: Colors.black12,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Text('Write Data to Clound Firestore',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                MyCustomForm(),
              ],
            ),
          ),
        ));
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  var name = '';
  var pricePerDay = 0;
  var imageUrl = '';
  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your product name',
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Plese enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter price per day',
                  labelText: 'Price per day',
                ),
                onChanged: (value) {
                  pricePerDay = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Plese enter some price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your product image url',
                  labelText: 'Image Url',
                ),
                onChanged: (value) {
                  imageUrl = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Plese enter some url';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Center(
                  child: ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Sending Data to Cloud Firestore'),
                    ));
                    products
                        .add({
                          'name': name,
                          'pricePerDay': pricePerDay,
                          'imageUrl': imageUrl
                        })
                        .then((value) => print('Product Added'))
                        .catchError(
                            (error) => print('Failed to add product: $error'));
                  }
                },
              ))
            ]),
      ),
    );
  }
}
