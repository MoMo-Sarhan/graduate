import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessegingApi {
  final _firebaseMessage = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMessage.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    final fCMToken = await _firebaseMessage.getToken();
    log(fCMToken!);
  }
}
