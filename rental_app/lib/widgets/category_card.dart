import 'package:flutter/material.dart';
import 'package:rental_app/models/models.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/catalog',
            arguments: category,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(category.imageUrl),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
