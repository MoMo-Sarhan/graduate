import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('home page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await BlocProvider.of<LoginStateCubit>(context).SignOut();
        },
      ),
    );
  }
}
