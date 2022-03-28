import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = review.text;
    final dateCreated = review.dateCreated;
    final rating = review.rating;
    final userId = review.userId;
    final userName = userId;
    final String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm').format(dateCreated.toDate());

    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(),
            title: Text(userName),
            subtitle: Text(formattedDate),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StarRating(rating: rating),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(rating.toStringAsFixed(0)),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                if(text != '') Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),
        ],
      ),
    );
  }
}