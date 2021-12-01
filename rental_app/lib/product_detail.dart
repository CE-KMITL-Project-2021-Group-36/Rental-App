import 'dart:convert';

import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.indigo),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.indigo,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.indigo,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.indigo[200],
          child: Column(
            children: [
              Container(
                color: Colors.lightGreen,
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: const Center(child: Text('picture')),
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'กล้อง Canon EOS พร้อมเลนส์ ให้เช่าราคาถูก',
                            style: TextStyle(
                              fontSize: 20,
                              //fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Container(
                      height: 32,
                      child: Row(children: [
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.yellow[600], size: 24),
                            Icon(Icons.star,
                                color: Colors.yellow[600], size: 24),
                            Icon(Icons.star,
                                color: Colors.yellow[600], size: 24),
                            Icon(Icons.star,
                                color: Colors.yellow[600], size: 24),
                            Icon(Icons.star_half,
                                color: Colors.yellow[600], size: 24),
                          ],
                        ),
                        Text('4.9'),
                        VerticalDivider(
                          color: Colors.grey,
                        ),
                        Text('เช่าแล้ว 33 ครั้ง'),
                      ]),
                    ),
                    Text(
                      '฿100 /ชม.\n฿700 /วัน\n฿4,500 /สัปดาห์',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ค่ามัดจำ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '''ราคาสินค้าจริง ฿50,000
เอกสาร 1 ชิ้น: 90% ของราคาสินค้า - ฿45,000
เอกสาร 2 ชิ้น: 70% ของราคาสินค้า - ฿35,000
เอกสาร 3 ชิ้น: 50% ของราคาสินค้า - ฿25,000
บัตรนักศึกษา: 30% ของราคาสินค้า - ฿15,000''',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
