import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:expense_tracker/main.dart';

import '../utility/applog.dart';

class FirebaseApi{
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {

    // request permission from user
    await _firebaseMessaging.requestPermission();

    // fetch the fcm token for this devices
    final fcmToken = await _firebaseMessaging.getToken();

    AppLog.d("Token: ", "${fcmToken.toString()}");

    initPushNotification();

  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message){
    // if message is null
    if(message == null) return;

    // navigate to new screen when message is received and use tap the notification
    navigatorKey.currentState?.pushNamed('/notificationPage',arguments: message);
  }

  // function to initialize foreground and background settings
  Future initPushNotification() async{
    // handle notification if the app was terminated and new opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //   attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}