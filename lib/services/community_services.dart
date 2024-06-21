import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduate/helper/constatn.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';

class CommunityServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<QuerySnapshot>? getPosts({UserModel? user}) {
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
        return _firebaseFirestore
            .collection(collection)
            .orderBy('time', descending: true)
            .get();
      } catch (e) {
        log(e.toString());
        return null;
      }
    } else {
      log('get no pots');
      return null;
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
          'userName': user.getFullName(),
          'commentNum': post.commentNum,
          'commentsList': post.commentsList,
          'time': post.time,
          'imagePath': post.imagePath,
          'likes': post.likes,
          'file': post.file,
          'ifIsLiked': post.ifIsLiked,
          'collection': collection,
          'likesList': post.likesList,
        });
      } catch (e) {
        log(e.toString());
      }
    } else {
      log('user is null');
    }
  }

  Future<String> getUserFullName(
      {required String uid, required UserModel userModel}) async {
    String collection;
    if (userModel.isStudent()) {
      collection = 'Students';
    } else if (userModel.isDoctor()) {
      collection = 'Doctors';
    } else {
      collection = 'Generals';
    }
    var userDoc =
        await _firebaseFirestore.collection(collection).doc(uid).get();
    UserModel userData = UserModel.fromDocs(userDoc);
    return userData.getFullName();
  }


  Stream<QuerySnapshot> searchPost(
      {UserModel? user, required String keyWord}) {
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
        return _firebaseFirestore
            .collection(collection)
            .where('content', isGreaterThanOrEqualTo: keyWord.toLowerCase())
            .where('content',
                isLessThanOrEqualTo: '${keyWord.toLowerCase()}\uf8ff')
            .snapshots();
      } catch (e) {
        log(e.toString());
        return const Stream.empty();
      }
    } else {
      log('get no pots founded');
      return const Stream.empty();
    }
  }

  Future<void> deletePost(
      {UserModel? user, required PostCardModel post}) async {
    if (user != null ) {
      if(user.uid!=post.userUid){
        throw Exception('You are not the owner of this post!');
      }
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
        await _firebaseFirestore
            .collection(collection)
            .doc(post.postId)
            .delete();
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }
  }
}
