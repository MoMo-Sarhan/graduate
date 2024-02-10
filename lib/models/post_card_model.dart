import 'package:cloud_firestore/cloud_firestore.dart';

class PostCardModel {
  String userName;
  String? postId;
  String userUid;
  Timestamp time;
  String content;
  int likes;
  List<dynamic> likesList;
  int commentNum;
  List<dynamic> commentsList;
  String? imagePath;
  String? file;
  String? collection;
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
    required this.userName,
    required this.imagePath,
    this.collection,
    required this.file,
    required this.likesList,
  });

  factory PostCardModel.fromDoc({required doc, required String postId,bool ifIsLiked=false}) {
    return PostCardModel(
      collection: doc['collection'],
        userName: doc['userName'],
        userUid: doc['userUid'],
        time: doc['time'],
        content: doc['content'],
        likes: doc['likes'],
        postId: postId,
        ifIsLiked:ifIsLiked,
        imagePath: doc['imagePath'],
        file: doc['file'],
        commentNum: doc['commentNum'],
        commentsList: doc['commentsList'],
        likesList: []
        // likesList: doc['likesList'],
        );
  }
}
