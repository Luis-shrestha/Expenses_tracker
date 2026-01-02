import 'package:flutter/material.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/utility/textStyle.dart';

class CustomSettingColumn extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final Color color;
  final VoidCallback onTap;

  const CustomSettingColumn({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(padding),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: mediumTextStyle(
                      textColor: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  subTitle,
                  style: regularTextStyle(textColor: Colors.grey, fontSize: 15),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    );
  }
}
