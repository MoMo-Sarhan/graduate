import 'dart:developer';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/auth/auth_services.dart';

class LoginStateCubit extends Cubit<SignUpState> {
  LoginStateCubit() : super(NotLoginYet());
  UserCredential? newUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future SignUpWithEmailandPassword({required UserModel user}) async {
    try {
      newUser = await AuthService().SignUpWithEmailAndPassword(user: user);
      if (newUser != null) {
        if (user.userType == 'Student') {
          log('User signed in as Student');
          emit(SignUpAsStudent());
        } else if (user.userType == 'Doctor') {
          log('User signed in as Student');
          emit(SignUpAsDoctor());
        } else {
          log('User login as general');
          emit(SignUpAsGeneral());
        }
      } else {
        throw ('Wrong credentials');
      }
    } on FirebaseException catch (_) {
      // ignore: unnecessary_null_comparison
      emit(NotLoginYet());
      throw Exception(_.code);
    }
  }
}
