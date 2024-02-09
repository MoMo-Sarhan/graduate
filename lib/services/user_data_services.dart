import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduate/models/user_model.dart';

class UserServices {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;

  Future<UserModel?> getStudentData({required String uid}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firebaseFirestore.collection('Students').doc(uid).get();
      if (doc.exists) {
        log('exits');
        return UserModel.fromDocs(doc);
      } else {
        log('not exits');
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> changeName(
      {required String firstName, required String lastName}) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update({
        'firstName': firstName,
        'lastName': lastName,
        'fullName': '$firstName $lastName',
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> changePhone({required int phoneNum}) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update({
        'phone': phoneNum,
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
