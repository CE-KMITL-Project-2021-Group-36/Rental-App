import 'package:flutter/material.dart';

class SetRating extends StatefulWidget {
  final int maximumRating;
  final Function(int) onRatingSelected;
  final int currentRating;

  SetRating(this.onRatingSelected, this.currentRating, [this.maximumRating = 5]);

  @override
  _Rating createState() => _Rating();
}

class _Rating extends State<SetRating> {
  int _currentRating = 1;

  Widget _buildRatingStar(int index) {
    if (index < widget.currentRating) {
      return const Icon(Icons.star, color: Colors.orange, size: 40);
    } else {
      return const Icon(Icons.star_border_outlined, color: Colors.orange, size: 40);
    }
  }

  Widget _buildBody() {
    final stars = List<Widget>.generate(widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });
          widget.onRatingSelected(_currentRating);
        },
      );
    });

    return Row(
      children: [
        Row(
          children: stars,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}