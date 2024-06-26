import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../widgets/register_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const id = 'Login Screen id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackGround(), // Background gradient
          RegisterForm(), // Form
        ],
      ),
    );
  }
}
