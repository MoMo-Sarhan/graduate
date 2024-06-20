import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/widgets/background.dart';
import 'package:graduate/widgets/custom_text.dart';
import 'package:graduate/widgets/custom_text_field.dart';
import 'dart:ui';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const id = 'Sign up Screen';

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  String _selectedDepartment = 'CS';
  String _selectedRole = 'General';
  String _selectedGender = 'male';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          const BackGround(),
          Form(
            key: formKey,
            child: SafeArea(
              child: Center(
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
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: IconButton(
                              //     icon: const Icon(Icons.arrow_back,
                              //         color: Colors.black),
                              //     onPressed: () {
                              //       // Handle back navigation
                              //       Navigator.of(context).pop();
                              //     },
                              //   ),
                              // ),
                              // Gradient Text "Sign Up"
                              const CustomText(
                                text: 'Register',
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Gender can not be null';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  fillColor: Colors.white.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.black),
                                ),
                                items: <String>[
                                  'male',
                                  'female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                                value: _selectedGender,
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null) {
                                    return 'User can not be null';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'User',
                                  fillColor: Colors.white.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.person_outline,
                                      color: Colors.black),
                                ),
                                items: <String>[
                                  'Student',
                                  'Doctor',
                                  'General'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedRole = newValue!;
                                  });
                                },
                                value: _selectedRole,
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Gender can not be null';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabled:
                                      _selectedRole == 'General' ? false : true,
                                  labelText: 'Department',
                                  fillColor: Colors.white.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.school,
                                      color: Colors.black),
                                ),
                                items: <String>[
                                  'CS',
                                  'AI',
                                  'IS',
                                  'SC'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDepartment = newValue!;
                                  });
                                },
                                value: _selectedDepartment,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: _selectedRole == 'Student'
                                          ? (value) {
                                              double x;
                                              try {
                                                x = double.parse(value!);
                                              } on FormatException {
                                                return 'Enter right gpa';
                                              } catch (e) {
                                                return e.toString();
                                              }

                                              if (x < 0 || x > 4) {
                                                return 'Enter  GPA between 0 and 4';
                                              }
                                              return null;
                                            }
                                          : null,
                                      enabled: _selectedRole == 'General'
                                          ? false
                                          : true,
                                      controller: _gpaController,
                                      decoration: InputDecoration(
                                        labelText: 'GPA',
                                        fillColor:
                                            Colors.white.withOpacity(0.2),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        prefixIcon: const Icon(Icons.grade,
                                            color: Colors.black),
                                      ),
                                      style: const TextStyle(
                                          color: Colors.black), // Text color
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      validator: _selectedRole != 'Student'
                                          ? null
                                          : (value) {
                                              int x;
                                              try {
                                                x = int.parse(value!);
                                              } on FormatException {
                                                return 'Enter level';
                                              } catch (e) {
                                                return e.toString();
                                              }

                                              if (x < 1 || x > 4) {
                                                return 'Enter  Level between 1 and 4';
                                              }
                                              return null;
                                            },

                                      controller: _levelController,
                                      decoration: InputDecoration(
                                        enabled: _selectedRole == 'General'
                                            ? false
                                            : true,
                                        labelText: 'Level',
                                        fillColor:
                                            Colors.white.withOpacity(0.2),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        prefixIcon: const Icon(Icons.stars,
                                            color: Colors.black),
                                      ),
                                      style: const TextStyle(
                                          color: Colors.black), // Text color
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Gender Dropdown
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter first name';
                                        }
                                        return null;
                                      },
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First Name',
                                        fillColor: Colors.white.withOpacity(
                                            0.2), // Slightly transparent background for text field
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter last name';
                                        }
                                        return null;
                                      },
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name',
                                        fillColor: Colors.white.withOpacity(
                                            0.2), // Slightly transparent background for text field
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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

                              // Role Dropdown

                              // Department Dropdown

                              // Email TextField
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  fillColor: Colors.white.withOpacity(
                                      0.2), // Slightly transparent background for text field
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.email,
                                      color: Colors.black),
                                ),
                                style: const TextStyle(
                                    color: Colors.black), // Text color
                              ),

                              const SizedBox(height: 20),
                              // Phone Number
                              TextFormField(
                                validator: (value) {
                                  try {
                                    int.parse(value!);
                                  } catch (e) {
                                    return "Please enter a valid Phone number";
                                  }
                                  if (value.isEmpty) return 'Enter phone';
                                  return null;
                                },
                                controller: _phoneNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  fillColor: Colors.white.withOpacity(
                                      0.2), // Slightly transparent background for text field
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.phone,
                                      color: Colors.black),
                                  prefix: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('+',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                                style: const TextStyle(
                                    color: Colors.black), // Text color
                              ),
                              const SizedBox(height: 20),
                              // GPA and Level Fields
                              // Password TextField
                              CustomTextField(
                                // Custom Password TextField
                                label: 'Password',
                                icon: Icons.lock,
                                visibilityIcon: true,
                                controller: _passwordController,
                                validFunc: (value) {
                                  if (value.isEmpty) return 'Enter Password';
                                  return null;
                                },
                              ),
                              const SizedBox(width: 20),
                              CustomTextField(
                                // Custom Password TextField
                                label: 'Confirm Password',
                                icon: Icons.lock,
                                visibilityIcon: true,
                                controller: _confirmPasswordController,
                                validFunc: (value) {
                                  if (value.isEmpty) return 'Enter Password';
                                  if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    return 'password is not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Register Button
                              ElevatedButton(
                                onPressed: signUp,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ),
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

  void signUp() async {
    if (formKey.currentState!.validate()) {
      UserModel user = UserModel(
          uid: null,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          gender: _selectedGender,
          email: _emailController.text,
          phone: _phoneNumberController.text,
          userType: _selectedRole,
          profileIcon:
              'https://firebasestorage.googleapis.com/v0/b/graduate-40eb5.appspot.com/o/default-profile.jpg?alt=media&token=30b6038b-6a47-4b33-be09-b7ba5eae018a',
          level: int.tryParse(_levelController.text),
          gpa: _gpaController.text.isNotEmpty
              ? double.parse(_gpaController.text)
              : null,
          department: int.tryParse(_levelController.text) == null ||
                  int.tryParse(_levelController.text)! < 3 ||
                  _selectedRole != 'Student'
              ? null
              : _selectedDepartment,
          password: _passwordController.text);

      try {
        await BlocProvider.of<LoginStateCubit>(context)
            .SignUpWithEmailandPassword(user: user);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(e.toString()),
              );
            });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
