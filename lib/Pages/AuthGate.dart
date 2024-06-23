import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/MainPage.dart';
import 'package:graduate/Pages/LoginPage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/cubits/Navigation_cubits/navigation_cubit.dart';
import 'package:graduate/screens/login_screen.dart';
import 'package:graduate/screens/onBoardingScreen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  static const id = 'Auth Gate';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginStateCubit, SignUpState?>(
      builder: (context, user) {
        if (user is NotLoginYet) {
          BlocProvider.of<NavigationCubit>(context).navigationToLogin();
        } else {
          BlocProvider.of<NavigationCubit>(context).navigationToHome();
        }
        return BlocBuilder<NavigationCubit, AppPage>(
            builder: (context, appPage) {
          if (appPage == AppPage.home) {
            return MainPage();
          } else {
            return LoginScreen();
          }
        });
      },
    );
  }
}
