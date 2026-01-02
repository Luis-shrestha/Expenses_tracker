import 'package:flutter/material.dart';

class CustomProceedButton extends StatefulWidget {
  final String titleName;
  const CustomProceedButton({Key? key,required this.titleName}) : super(key: key);

  @override
  State<CustomProceedButton> createState() => _CustomProceedButtonState();
}

class _CustomProceedButtonState extends State<CustomProceedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0,top:10.0,bottom: 10),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.blue,
        ),
        child:  Center(
          child: Text(widget.titleName,style: TextStyle(color: Colors.white,fontSize: 14,
              fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

  }
}
