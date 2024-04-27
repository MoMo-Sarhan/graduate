import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  static const String routeName = '/notification-page';

  @override
  Widget build(BuildContext context) {
    final _message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text("${_message.notification?.title}"),
          Text("${_message.notification?.body}"),
          Text("${_message.data}"),
        ],
      ),
    );
  }
}
