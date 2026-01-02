import 'package:flutter/material.dart';
import 'package:expense_tracker/utility/textStyle.dart';

class CustomProfileDataContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const CustomProfileDataContainer(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(
              icon,
              size: 25,
            ),
          ),
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: regularTextStyle(textColor: Colors.black, fontSize: 16),
              ),
              Text(
                subTitle,
                style:
                    regularTextStyle(textColor: Colors.black54, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
