import 'package:flutter/material.dart';
import 'package:graduate/Pages/AuthGate.dart';
import 'package:graduate/Pages/MainPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = 'splash screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Example code to navigate to main app screen after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AuthGate.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your splash screen UI
      body: Center(
        child: Image.asset(
            'assets/logo.png'), // Replace with your splash screen image asset path
      ),
    );
  }
}
