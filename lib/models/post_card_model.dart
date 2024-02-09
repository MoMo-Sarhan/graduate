import 'package:cloud_firestore/cloud_firestore.dart';

class PostCardModel {
  String? postId;
  String userUid;
  Timestamp time;
  String content;
  String? imagePath;
  int likes;
  List<dynamic> likesList;
  int commentNum;
  List<dynamic> commentsList;
  String? file;
  bool? ifIsLiked;

  PostCardModel({
    required this.userUid,
    required this.time,
    required this.content,
    required this.likes,
    required this.postId,
    this.ifIsLiked,
    required this.commentNum,
    required this.commentsList,
    this.imagePath,
    this.file,
    required this.likesList,
  });

  factory PostCardModel.fromDoc({required doc, required String postId}) {
    return PostCardModel(
        userUid: doc['userUid'],
        time: doc['time'],
        content: doc['content'],
        likes: doc['likes'],
        postId: postId,
        ifIsLiked: null,
        commentNum: doc['commentNum'],
        commentsList: doc['commentsList'],
        likesList: []
        // likesList: doc['likesList'],
        );
  }
}
