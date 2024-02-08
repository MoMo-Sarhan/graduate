import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child:
            Text(BlocProvider.of<LoginStateCubit>(context).currentUser!.email!),
        onPressed: () {
          BlocProvider.of<LoginStateCubit>(context).SignOut();
        },
      )),
    );
  }
}
