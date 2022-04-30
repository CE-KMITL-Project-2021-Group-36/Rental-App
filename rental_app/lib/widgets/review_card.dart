import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/config/palette.dart';
import 'package:rental_app/models/models.dart';
import 'package:rental_app/widgets/widget.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final Product product;
  final String userName;
  final String avatarUrl;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.product,
    required this.userName,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = review.text;
    final dateCreated = review.dateCreated;
    final rating = review.rating;
    final imageUrl = review.imageUrl;
    final String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm').format(dateCreated.toDate());
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            ),
            title: Row(
              children: [
                Text(userName),
                const Expanded(child: SizedBox()),
                review.userId == currentUserId
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/add_review',
                                arguments: product,
                              );
                            },
                            child: const Text(
                              'แก้ไข',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
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
                if (text != '')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                imageUrl.isNotEmpty
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: imageUrl.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                        ),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 100),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl[index],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          );
                        })
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
