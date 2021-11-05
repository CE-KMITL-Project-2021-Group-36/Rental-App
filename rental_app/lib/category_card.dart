import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      child: Container(
        width: 88,
        height: 132,
        child: Column(
          children: [
            Container(
              height: 88,
              color: Colors.indigo,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('ทดสอบชนิดสินค้า', style: TextStyle(fontSize: 10)),
            ),
          ],
        )
      ),
    );
  }
}