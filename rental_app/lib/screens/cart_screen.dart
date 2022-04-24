import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<bool> isCardEnabled = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รถเข็น'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildShopCart('ShopName', ['A', 'B', 'C', 'D', 'E', 'F']),
              _buildShopCart('ShopName', ['A', 'B', 'C', 'D', 'E', 'F']),
              _buildShopCart('ShopName', ['A', 'B', 'C', 'D', 'E', 'F']),
              _buildShopCart('ShopName', ['A', 'B', 'C', 'D', 'E', 'F']),
              _buildShopCart('ShopName', ['A', 'B', 'C', 'D', 'E', 'F']),
            ],
          ),
        ),
      ),
    );
  }

  _buildShopCart(shopName, item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            children: [
              const Icon(Icons.store),
              Text(shopName),
              const Expanded(
                child: SizedBox(),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text(
                      'ไปที่ร้าน',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
          _buildItem(shopName, item),
          _buildItem(shopName, item),
          _buildItem(shopName, item),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: const [
              Text('รวมทั้งหมด'),
              Expanded(
                child: SizedBox(),
              ),
              Text('500'),
            ],
          ),
        ],
      ),
    );
  }

  _buildItem(shopName, item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
                    'https://www.w3schools.com/w3css/img_lights.jpg',
                    fit: BoxFit.cover,
                    height: 60.0,
                    width: 60.0,
                    color: primaryColor,
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
                      'productname',
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
                      'เช่าวันที่',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'ระยะเวลาวัน',
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
        ],
      ),
    );
  }
}
