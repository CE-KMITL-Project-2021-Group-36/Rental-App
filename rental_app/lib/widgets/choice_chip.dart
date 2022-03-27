import 'package:flutter/material.dart';
import 'package:rental_app/config/palette.dart';

class ChoiceChipWidget extends StatefulWidget {
  final List<String> reportList;
  final Function(String) onselectedChoiceSelected;

  ChoiceChipWidget(this.reportList, this.onselectedChoiceSelected);

  @override
  _ChoiceChipWidgetState createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: selectedChoice == item ? Colors.white : textColor, fontSize: 14.0,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: outlineColor,
          selectedColor: primaryColor,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
