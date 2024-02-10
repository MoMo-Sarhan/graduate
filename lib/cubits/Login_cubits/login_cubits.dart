import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/auth/auth_services.dart';
import 'package:graduate/services/user_data_services.dart';

class LoginStateCubit extends Cubit<SignUpState> {
  LoginStateCubit() : super(LoginState());
  final AuthService _authService = AuthService();
  User? currentUser;
  UserModel? userModel;

  void checAuth() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(NotLoginYet());
    } else {
      userModel = await UserServices().getStudentData(uid: currentUser!.uid);
      if (userModel!.isDoctor()) {
        emit(SignUpAsDoctor());
      } else if (userModel!.isStudent()) {
        emit(SignUpAsStudent());
      } else if (userModel!.isGeneral()) {
        emit(SignUpAsGeneral());
      }
    }
  }

  Future<void> SignOut() async {
    await FirebaseAuth.instance.signOut();
    userModel = null;
    emit(NotLoginYet());
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final user = await _authService.SignInWithEmailAndPassword(
        email: email, password: password);
    userModel = await UserServices()
        .getStudentData(uid: FirebaseAuth.instance.currentUser!.uid);
    currentUser = user.user;

    if (userModel!.isDoctor()) {
      emit(SignUpAsDoctor());
    } else if (userModel!.isStudent()) {
      emit(SignUpAsStudent());
    } else if (userModel!.isGeneral()) {
      emit(SignUpAsGeneral());
    }
  }

  Future<void> SignUpWithEmailandPassword({required UserModel user}) async {
    try {
      final newUser = await _authService.SignUpWithEmailAndPassword(user: user);
      userModel = await UserServices()
          .getStudentData(uid: FirebaseAuth.instance.currentUser!.uid);
      currentUser = newUser.user;
      if (currentUser == null) emit(NotLoginYet());
      if (user.isStudent()) emit(SignUpAsStudent());
      if (user.isDoctor()) emit(SignUpAsDoctor());
      if (user.isGeneral()) emit(SignUpAsGeneral());
    } on FirebaseException catch (_) {
      // ignore: unnecessary_null_comparison
      emit(NotLoginYet());
      throw Exception(_.code);
    }
  }
}
