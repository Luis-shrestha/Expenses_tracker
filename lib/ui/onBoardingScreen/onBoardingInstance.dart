import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onBoardingList/onBoardingListData.dart';

class OnBoardingInstance extends StatelessWidget {
  final OnBoardingData onBoardingData;

  const OnBoardingInstance({Key? key, required this.onBoardingData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: [
              Opacity(
                opacity: 0.6,
                child: Container(
                  height: height * 0.5,
                  color:Colors.white,
                ),
              ),

              Center(
                child: Image.asset(
                  onBoardingData.image,
                  height: height * 0.5,
                ) /*.animate().scale(duration: 1000.ms)*/,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            onBoardingData.title,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ).animate().slideX(begin: -2, duration: 900.ms),
          const Padding(padding: EdgeInsets.all(16)),
          Text(onBoardingData.description)
              .animate()
              .slideX(begin: 5, duration: 1000.ms),
        ],
      ),
    );
  }
}
