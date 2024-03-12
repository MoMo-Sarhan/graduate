import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? id;
  String uid;
  String userName;
  String content;
  Timestamp time;
  CommentModel({
    this.id,
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
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'content': content,
      'time': time,
      'userName': userName,
    };
  }
}
