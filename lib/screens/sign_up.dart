import 'package:flutter/material.dart';
import 'dart:ui';

import '../../widgets/background.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart'; // Required for BackdropFilter

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const id = 'sign_upScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          const BackGround(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                            0.4), // Increased opacity for more white
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back Button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () {
                                // Handle back navigation
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Logo
                          Image.network(
                            'https://via.placeholder.com/150', // Placeholder image for logo
                            height: 50,
                          ),
                          const SizedBox(height: 20),
                          // Gradient Text "Sign Up"
                          const CustomText(
                            text: 'Sign Up',
                          ),
                          const SizedBox(height: 10),
                          // Login Prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle login navigation
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // First Name and Last Name Fields
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    fillColor: Colors.white.withOpacity(
                                        0.2), // Slightly transparent background for text field
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.person,
                                        color: Colors.black),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.black), // Text color
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    fillColor: Colors.white.withOpacity(
                                        0.2), // Slightly transparent background for text field
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.person,
                                        color: Colors.black),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.black), // Text color
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Email TextField
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              fillColor: Colors.white.withOpacity(
                                  0.2), // Slightly transparent background for text field
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.black),
                            ),
                            style: const TextStyle(
                                color: Colors.black), // Text color
                          ),
                          const SizedBox(height: 20),
                          // Birth of date
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Birth of date',
                              fillColor: Colors.white.withOpacity(
                                  0.2), // Slightly transparent background for text field
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today,
                                  color: Colors.black),
                            ),
                            style: const TextStyle(
                                color: Colors.black), // Text color
                          ),
                          const SizedBox(height: 20),
                          // Phone Number
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              fillColor: Colors.white.withOpacity(
                                  0.2), // Slightly transparent background for text field
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.phone, color: Colors.black),
                              prefix: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('+',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.black), // Text color
                          ),
                          const SizedBox(height: 20),
                          // Password TextField
                          CustomTextField(
                            validFunc: (value) {},
                            controller: TextEditingController(),
                            // Custom Password TextField
                            label: 'Password',
                            icon: Icons.lock,
                            visibilityIcon: true,
                          ),
                          const SizedBox(height: 20),
                          // Register Button
                          ElevatedButton(
                            onPressed: () {
                              // Handle registration
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
                            child: const Text('Register'),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
