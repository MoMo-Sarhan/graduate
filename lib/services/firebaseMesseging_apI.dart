import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessegingApi {
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessage.requestPermission(
      provisional: true,
      alert: true,
      sound: true,
      badge: true,
    );
    final fCMToken = await _firebaseMessage.getToken();
    log("heeeer:${fCMToken}");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Title:${message.notification?.title}');
  log('body:${message.notification?.body}');
  log('payload:${message.data}');
}
