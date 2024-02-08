import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/Pages/LoginPage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/cubits/Navigation_cubits/navigation_cubit.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
            return HomePage();
          } else {
            return LoginPage();
          }
        });
      },
    );
  }
}

// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:graduate/Pages/HomePage.dart';
// import 'package:graduate/Pages/LoginPage.dart';

// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, AsyncSnapshot<User?> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasData) {
//             return HomePage();
//           } else if (snapshot.hasError) {
//             log(snapshot.error.toString());
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           }
//           return LoginPage();
//         });
//   }
// }
