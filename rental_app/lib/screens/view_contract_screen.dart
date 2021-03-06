import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/config/theme.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/screens/confirm_deposit.dart';
import 'package:rental_app/screens/screens.dart';
import 'package:rental_app/widgets/widget.dart';

class ViewContractScreen extends StatefulWidget {
  const ViewContractScreen(
      {Key? key, required this.contract, required this.userType})
      : super(key: key);

  @override
  State<ViewContractScreen> createState() => _ViewContractScreenState();
  final Contract contract;
  final String userType;
}

class _ViewContractScreenState extends State<ViewContractScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference contracts =
      FirebaseFirestore.instance.collection("contracts");

  String productName = '';

  @override
  void initState() {
    super.initState();
    _findProductName();
  }

  _findProductName() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.contract.productId)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      productName = data?['name'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.contract.startDate.toDate();
    DateTime endDate = widget.contract.endDate.toDate();
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);
    final bool isRenter = currentUserId == widget.contract.renterId;
    double inputDeposit = 0;

    @override
    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text(
          "???????????????????????????",
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        style: TextButton.styleFrom(
          //primary: errorColor,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text("??????????????????????????????????????????"),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
        onPressed: () async {
          final ref = contracts.doc(widget.contract.id);
          await ref.update({
            'renterStatus': '??????????????????????????????',
            'ownerStatus': '??????????????????????????????',
          });
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('??????????????????????????????????????????????????????'),
          ));
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("??????????????????????????????????????????????????????????????????????????????????"),
        //content: const Text("?????????????????????????????????????????????????????????????????????????????????"),
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

    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('????????????????????????'),
          actions: <Widget>[
            TextButton(
              child: Row(
                children: [
                  isRenter
                      ? const Text(
                          '????????????????????????????????????????????????',
                          style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.normal),
                        )
                      : const Text(
                          '???????????????????????????????????????',
                          style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.normal),
                        )
                ],
              ),
              onPressed: () {
                isRenter
                    ? enterChatRoom(
                        context: context,
                        currentUserId: currentUserId,
                        chatWithUser: widget.contract.ownerId,
                        message: widget.contract.id,
                        messageType: 'contract')
                    : enterChatRoom(
                        context: context,
                        currentUserId: currentUserId,
                        chatWithUser: widget.contract.renterId,
                        message: widget.contract.id,
                        messageType: 'contract');
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .doc(widget.contract.productId)
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
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(
                                  color: outlineColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            '????????????????????????????????????',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????'
                                            .replaceAll('\\n', '\n'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/product',
                                            arguments:
                                                Product.fromSnapshot(product),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: SizedBox.fromSize(
                                            child: Image.network(
                                              product['imageUrl'][0],
                                              fit: BoxFit.cover,
                                              height: 100.0,
                                              width: 100.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              '?????????????????????????????? $formattedStartDate ????????? $formattedEndDate',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const Text(
                                              '??????????????????????????????????????????????????????',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '???' +
                                                      currencyFormat(widget
                                                          .contract
                                                          .rentalPrice),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(thickness: 0.6, height: 32),
                                  const Text(
                                    '????????????????????????????????????????????????',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product['deposit'].replaceAll('\\n', '\n'),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '??????????????????????????????????????????????????????',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            widget.contract.renterAttachments.isNotEmpty
                                ? GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .contract.renterAttachments.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 100),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image(
                                                image: NetworkImage(widget
                                                    .contract
                                                    .renterAttachments[index]),
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                        ],
                                      );
                                    })
                                : const Text(
                                    '??????????????????????????????????????????',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            const SizedBox(height: 32),
                            widget.contract.renterAddressName == ''
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: outlineColor,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              '??????????????????????????????????????????',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(widget.contract.renterAddressName),
                                        Text(
                                            widget.contract.renterAddressPhone),
                                        Text(widget.contract.renterAddress),
                                      ],
                                    ),
                                  ),
                            const SizedBox(height: 32),
                            widget.userType == 'renter'
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                showAlertDialog(context);
                                              },
                                              child:
                                                  const Text('??????????????????????????????????????????'),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: errorColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(thickness: 0.6, height: 32),
                                      const Text(
                                        '????????????????????????????????????',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        onChanged: (text) {
                                          if (text.isNotEmpty) {
                                            inputDeposit = double.parse(text);
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          hintText: '????????????????????????????????????????????????',
                                          suffix: Text('?????????'),
                                          alignLabelWithHint: true,
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height: 32),
                                      Row(children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            showAlertDialog(context);
                                          },
                                          child: const SizedBox(
                                            width: 140,
                                            child:
                                                Center(child: Text("??????????????????")),
                                          ),
                                          style: TextButton.styleFrom(
                                            primary: errorColor,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: const BorderSide(
                                                  color: errorColor, width: 1),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmDeposit(
                                                    contract: widget.contract,
                                                    deposit: inputDeposit,
                                                    productName: productName,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text("?????????????????????"),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ])
                                    ],
                                  ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Text('??????????????????????????????????????????');
            }),
      ),
    );
  }
}
