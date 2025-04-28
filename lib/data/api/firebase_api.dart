import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  // create an instance of the Firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notification
  Future<String?> initNotification() async {
    //request permission
    await _firebaseMessaging.requestPermission();

    //fetch the fcm token
    final fcmToken = await _firebaseMessaging.getToken();

    //print the token
    debugPrint("Token: $fcmToken");

    //return the fcm token
    return fcmToken;
  }

  // function to handle received notifications
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  // function to initialize foreground and background settings
}
