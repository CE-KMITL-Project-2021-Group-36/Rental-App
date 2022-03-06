import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class StarRating extends StatelessWidget {
  final double rating;
  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconSize = 20.0;
    var iconColor = warningColor;
    if (rating == 5) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 4.5) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_half, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 4) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 3.5) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_half, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 3) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 2.5) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_half, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 2) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 1.5) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_half, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    } else if (rating >= 1) {
      return Row(
        children: [
          Icon(Icons.star, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
          Icon(Icons.star_border, color: iconColor, size: iconSize),
        ],
      );
    }
    return const Text('');
  }
}
