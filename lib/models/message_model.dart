import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String reciverId;
  final String message;
  final Timestamp timestamp;
  MessageModel(
      {required this.message,
      required this.reciverId,
      required this.senderId,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromDoc(doc) {
    return MessageModel(
        message: doc['message'],
        reciverId: doc['reciverId'],
        senderId: doc['senderId'],
        timestamp: doc['timestamp']);
  }
}
