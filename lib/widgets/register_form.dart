import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/RegisterPage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';

import '../screens/home_screen.dart';
import '../screens/sign_up.dart';
import 'check_box.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.4), // Increased opacity for more white
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.0,
                  ),
                ),
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.network(
                        'https://via.placeholder.com/150', // Placeholder image for logo
                        height: 50,
                      ),
                      const SizedBox(height: 20),
                      // Gradient Text "Get Started now"

                      const CustomText(
                        text: 'Get Started now',
                      ),

                      const SizedBox(height: 10),
                      // Subtitle
                      const Text(
                        'Create an account or log in to explore our app',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      // Email TextField
                      CustomTextField(
                        validFunc: (value) {
                          if (value!.isEmpty) return "Please Enter Email";
                          return null;
                        },
                        controller: _emailController,
                        // Custom Email TextField
                        label: 'Email',
                        icon: Icons.email,
                        visibilityIcon: false,
                      ),
                      const SizedBox(height: 20),
                      // Password TextField
                      CustomTextField(
                        validFunc: (value) {
                          if (value!.isEmpty) return 'Enter Password';
                          return null;
                        },
                        controller: _passwordController,
                        // Custom Password TextField
                        label: 'Password',
                        icon: Icons.lock,
                        visibilityIcon: true,
                      ),

                      const SizedBox(height: 10),
                      // Remember Me and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              CustomCheckBox(),
                              Text('Remember me',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: const Text('Forgot Password?',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Log In Button
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.formKey.currentState!.validate()) {
                            try {
                              await BlocProvider.of<LoginStateCubit>(context)
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Center(
                                          child: Text(
                                            "Wrong email or password ${e.toString()}",
                                            style: TextStyle(fontSize: 19),
                                          ),
                                        ),
                                        content: Image.asset(
                                            'assets/images/rate_icons/3.png'),
                                      ));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(
                              double.infinity, 50), // Full-width button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Log In'),
                      ),
                      const SizedBox(height: 20),
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(color: Colors.black)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, SignUpScreen.id);
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
