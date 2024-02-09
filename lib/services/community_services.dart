import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduate/helper/constatn.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';

class CommunityServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPosts({required UserModel user}) {
    if (user != null) {
      String collection;
      if (user.isGeneral()) {
        collection = kGeneralCollection;
      } else {
        /**
         * student collection  
         * if level 1
         * if level 2
         * if level 3   which department
         * if level 4   which department
         *  */
        collection = 'StudentPostsLevel_${user.level}_${user.department}';
      }
      try {
        return _firebaseFirestore.collection(collection).snapshots();
      } catch (e) {
        log(e.toString());
        return const Stream.empty();
      }
    } else {
      log('get no pots');
      return const Stream.empty();
    }
  }

  Future<void> addPost({required PostCardModel post, UserModel? user}) async {
    if (user != null) {
      String collection;
      if (user.isGeneral()) {
        collection = kGeneralCollection;
      } else {
        collection = 'StudentPostsLevel_${user.level}_${user.department}';
      }
      try {
        await _firebaseFirestore.collection(collection).doc().set({
          'content': post.content,
          'userUid': post.userUid,
          'commentNum': post.commentNum,
          'commentsList': post.commentsList,
          'time': post.time,
          'imagePath': post.imagePath,
          'likes': post.likes,
          'file': post.file,
          'ifIsLiked': post.ifIsLiked,
        });
      } catch (e) {
        log(e.toString());
      }
    } else {
      log('user is null');
    }
  }
}
