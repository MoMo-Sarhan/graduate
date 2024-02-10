import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String uid;
  String userName;
  String content;
  Timestamp time;
  CommentModel({
    required this.uid,
    required this.content,
    required this.time,
    required this.userName,
  });

  factory CommentModel.fromDoc(doc) {
    return CommentModel(
        uid: doc['uid'],
        content: doc['content'],
        time: doc['timestamp'],
        userName: doc['userName']);
  }
}
