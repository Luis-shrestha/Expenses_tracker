import 'package:flutter/material.dart';
import 'package:expense_tracker/ui/reusableWidget/CustomListCard.dart';
import 'package:expense_tracker/utility/textStyle.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your Goals",
            style: regularTextStyle(textColor: Colors.black, fontSize: 15),
          ),
          SizedBox(height: 8.0),
          CustomListCard(
            category: "Foods and Drinks",
            amount: 600.0,
            categoryImageIcon: Image.asset("assets/icons/camera.png"),
            mainImageIcon: Image.asset("assets/icons/camera.png"),
          ),
        ],
      ),
    );
  }
}
