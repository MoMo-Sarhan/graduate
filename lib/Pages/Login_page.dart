import 'package:flutter/material.dart';
import 'package:graduate/helper/constatn.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static const String ID = 'LoginPage';
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: widget.formKey,
      child: ListView(children: [
        const SizedBox(
          height: 50,
        ),
        Image.asset(
          kCollegeIcon,
          height: 100,
        ),
        
      ]),
    ));
  }
}
