import 'package:flutter/material.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/utility/textStyle.dart';

import '../../configs/palette.dart';

class CustomListCard extends StatelessWidget {
  final IconData? categoryIcon;
  final String category;
  final double amount;
  final IconData? mainIcon;
  final Image? categoryImageIcon;
  final Image? mainImageIcon;

  const CustomListCard({
    super.key,
    this.categoryIcon,
    required this.category,
    required this.amount,
    this.mainIcon,
    this.categoryImageIcon,
    this.mainImageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(padding),
      margin: const EdgeInsets.all(4.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 1,
            color: Colors.black54,
          ),
        ],
      ),
      child: Row(
        children: [
          if (categoryImageIcon != null)
            SizedBox(
              width: 20.0, // Adjust width as needed
              height: 20.0, // Adjust height as needed
              child: categoryImageIcon,
            ),
          if (categoryIcon != null)
            Icon(
              categoryIcon,
              color: Palette.categoryTextColor,
            ),
          SizedBox(width: 8.0), // Provide spacing between icon and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: regularTextStyle(
                    textColor: Palette.categoryTextColor,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4.0), // Provide spacing between text lines
                Text(
                  "NPR. $amount",
                  style: mediumTextStyle(
                    textColor: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          if (categoryImageIcon != null)
            SizedBox(
              width: 30.0,
              height: 30.0,
              child: mainImageIcon,
            ),
          if (mainIcon != null)
            Icon(
              mainIcon,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
