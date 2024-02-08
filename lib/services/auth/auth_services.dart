import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> SignUpWithEmailAndPassword(
      {required UserModel user}) async {
    String collection = user.isGeneral()
        ? "General"
        : user.isStudent()
            ? "Students"
            : "Doctors";
    try {
      UserCredential newUser =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: user.password);

      _firebaseFirestore.collection(collection).doc(newUser.user!.uid).set({
        'uid': newUser.user!.uid,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'gender': user.gender,
        'phone': user.phone,
        'email': user.email,
        'userType': user.userType,
        'department': user.department,
        'gpa': user.gpa,
        'level': user.level,
        'profileIcon': user.profileIcon,
      }, SetOptions(merge: true));
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  void SignInWithEmailAndPassword(
      {required String email, required String password}) async {}
}
