import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/configs/palette.dart';
import 'package:flutter/material.dart';

import '../../../../utility/textStyle.dart';

class IncomeExpensesCardView extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final Color textColor;

  const IncomeExpensesCardView(
      {super.key,
      required this.title,
      required this.amount,
      required this.icon,
      required this.color,
      required this.iconColor,
      required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(halfPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Palette.primaryContainer,
          boxShadow: [
            BoxShadow(
                spreadRadius: 0,
                color: Colors.black12,
                blurRadius: 10.0
            )
          ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            minRadius: 25,
            child: Icon(
              icon,
              size: 35,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: regularTextStyle(textColor: textColor, fontSize: 15),
              ),
              Text(
                'Rs. $amount',
                style: regularTextStyle(
                    textColor: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }
}
