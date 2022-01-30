import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: outlineColor, width: 1),
          borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/product');
        },
        child: SizedBox(
          width: 164,
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ink.image(
                height: 160,
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      //Star
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(children: const [
                          Icon(Icons.star, color: warningColor, size: 16),
                          Icon(Icons.star, color: warningColor, size: 16),
                          Icon(Icons.star, color: warningColor, size: 16),
                          Icon(Icons.star, color: warningColor, size: 16),
                          Icon(Icons.star, color: warningColor, size: 16),
                          Text('(12)', style: TextStyle(
                                fontSize: 12, color: Colors.grey),)
                        ]),
                      ),
                      //Price
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            product.price,
                            style: const TextStyle(
                                fontSize: 16, color: primaryColor),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),//Image.asset('assets/card-sample-image-2.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
