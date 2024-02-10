import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduate/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> SignUpWithEmailAndPassword(
      {required UserModel user}) async {
    // String collection;
    // if (user.isGeneral())
    //   collection = 'General';
    // else if (user.isDoctor())
    //   collection = 'Doctors';
    // else {
    //   collection = '${user.userType}Level_${user.level}_${user.department}';
    // }
    String collection = 'users';
    try {
      UserCredential newUser =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: user.password!);

      _firebaseFirestore.collection(collection).doc(newUser.user!.uid).set({
        'uid': newUser.user!.uid,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'fullName': user.getFullName(),
        'gender': user.gender,
        'phone': user.phone,
        'email': user.email,
        'userType': user.userType,
        'department': user.department,
        'gpa': user.gpa,
        'level': user.level,
        'profileIcon': user.profileIcon,
        'courses': user.courses,
      }, SetOptions(merge: true));
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<UserCredential> SignInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }
}
