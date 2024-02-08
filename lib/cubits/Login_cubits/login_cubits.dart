import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/auth/auth_services.dart';

class LoginStateCubit extends Cubit<SignUpState> {
  LoginStateCubit() : super(NotLoginYet());
  final AuthService _authService = AuthService();
  User? currentUser;

  void checAuth() {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) ;
    emit(NotLoginYet());
  }

  Future<void> SignOut() async {
    await FirebaseAuth.instance.signOut();
    emit(NotLoginYet());
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final user = await _authService.SignInWithEmailAndPassword(
        email: email, password: password);
    currentUser = user.user;
    emit(LoginState());
  }

  Future<void> SignUpWithEmailandPassword({required UserModel user}) async {
    try {
      final newUser = await _authService.SignUpWithEmailAndPassword(user: user);
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
