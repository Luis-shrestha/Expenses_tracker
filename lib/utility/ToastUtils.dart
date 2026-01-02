

import 'package:fluttertoast/fluttertoast.dart';

import '../configs/palette.dart';

class Toastutils {

  /*showToast( String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Palette.toastColor,
    textColor: Palette.toastTextColor);
  }*/
 static showToast(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Palette.primaryColor,
        textColor: Palette.secondaryColor);
  }
}