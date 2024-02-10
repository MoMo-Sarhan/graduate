import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/LoginPage.dart';
import 'package:graduate/component/CustomButton.dart';
import 'package:graduate/component/custom_text_filed.dart';
import 'package:graduate/component/dropDownGender.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/helper/constatn.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static const String ID = 'Register Page';
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<String> genderOptions = ['male', 'female'];
  String gender = 'male';
  final List<String> userTypeOptions = ['General', 'Student', 'Doctor'];
  String userType = 'General';
  final List<String> departmentOptions = ['CS', 'AI', 'IS', 'SC'];
  String department = 'CS';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  bool isChecked = false;
  bool showPassWord = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpeg'), fit: BoxFit.fill)),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            SafeArea(
              child: Image.asset(
                kCollegeIcon,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Center(
              child: Text('Register',
                  style: TextStyle(fontSize: 30, fontFamily: 'pacifico')),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:
                    ListView(physics: const BouncingScrollPhysics(), children: [
                  CustomDropDown(
                      isEnabled: true,
                      onChange: (value) {
                        gender = value!;
                      },
                      items: genderOptions,
                      leading: 'Gender',
                      value: gender,
                      validator: (value) {
                        if (value == null) {
                          return 'Gender can not be null';
                        }
                        return null;
                      }),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDown(
                            isEnabled: true,
                            onChange: (value) {
                              userType = value!;
                              setState(() {});
                              log(userType);
                            },
                            items: userTypeOptions,
                            leading: 'User    ',
                            value: userType,
                            validator: (value) {
                              if (value == null) {
                                return 'User can not be null';
                              }
                              return null;
                            }),
                      ),
                      Expanded(
                        child: CustomDropDown(
                            isEnabled: userType != 'General' ? true : false,
                            onChange: (value) {
                              department = value!;
                              log(department);
                            },
                            items: departmentOptions,
                            leading: 'Department',
                            value: department,
                            validator: (value) {
                              if (value == null) {
                                return 'Gender can not be null';
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormFiled(
                          isEnabled: true,
                          prefixIcon: const Icon(Icons.person),
                          obscureText: false,
                          onChange: (data) {
                            log(_firstNameController.text);
                          },
                          validator: (value) {
                            if (value.isEmpty) return 'Enter first name';
                            return null;
                          },
                          controller: _firstNameController,
                          label: 'First Name',
                          hintText: 'Enter First Name',
                        ),
                      ),
                      Expanded(
                        child: CustomTextFormFiled(
                          isEnabled: true,
                          prefixIcon: const Icon(Icons.person),
                          obscureText: false,
                          onChange: (data) {
                            log(_lastNameController.text);
                          },
                          validator: (value) {
                            if (value.isEmpty) return 'Enter Last Name';
                            return null;
                          },
                          controller: _lastNameController,
                          label: 'Last Name',
                          hintText: 'Enter Last Name',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormFiled(
                          isEnabled: userType == 'Student' ? true : false,
                          prefixIcon: const Icon(Icons.grade_outlined),
                          obscureText: false,
                          onChange: (data) {
                            log(_gpaController.text);
                          },
                          validator: userType == 'Student'
                              ? (value) {
                                  double x;
                                  try {
                                    x = double.parse(value);
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
                          controller: _gpaController,
                          label: 'GPA',
                          hintText: 'GPA',
                        ),
                      ),
                      Expanded(
                        child: CustomTextFormFiled(
                          isEnabled: userType == 'Student' ? true : false,
                          prefixIcon: const Icon(Icons.grade_outlined),
                          obscureText: false,
                          onChange: (data) {
                            log(_levelController.text);
                          },
                          validator: userType != 'Student'
                              ? null
                              : (value) {
                                  int x;
                                  try {
                                    x = int.parse(value);
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
                          label: 'Level',
                          hintText: 'Level',
                        ),
                      ),
                    ],
                  ),
                  CustomTextFormFiled(
                    isEnabled: true,
                    prefixIcon: const Icon(Icons.phone_iphone_outlined),
                    obscureText: false,
                    onChange: (data) {
                      log(_phoneNumberController.text);
                    },
                    validator: (value) {
                      int phone;
                      try {
                        phone = int.parse(value);
                      } catch (e) {
                        return "Please enter a valid Phone number";
                      }
                      if (value.isEmpty) return 'Enter phone';
                      return null;
                    },
                    controller: _phoneNumberController,
                    label: 'Phone',
                    hintText: 'Enter Phone',
                  ),
                  CustomTextFormFiled(
                    isEnabled: true,
                    prefixIcon: const Icon(Icons.email_outlined),
                    obscureText: false,
                    onChange: (data) {
                      log(_emailController.text);
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Email';
                      return null;
                    },
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Enter Email',
                  ),
                  CustomTextFormFiled(
                    isEnabled: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: showPassWord,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassWord = !showPassWord;
                          });
                        },
                        icon: Icon(showPassWord
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    onChange: (data) {
                      log(_passwordController.text);
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Password';
                      return null;
                    },
                    controller: _passwordController,
                    label: 'Passowrd',
                    hintText: 'Enter Passowrd',
                  ),
                  CustomTextFormFiled(
                    isEnabled: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: showPassWord,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassWord = !showPassWord;
                          });
                        },
                        icon: Icon(showPassWord
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    onChange: (data) {
                      log(_confirmPasswordController.text);
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Password';
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return 'password is not match';
                      }
                      return null;
                    },
                    controller: _confirmPasswordController,
                    label: 'Confirm Passowrd',
                    hintText: 'Confrm Passowrd',
                  ),
                ]),
              ),
            ),
            CustomButton(
              onPressed: signUp,
              formKey: widget.formKey,
              buttonText: 'Sign Up',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Login'),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  void signUp() async {
    if (widget.formKey.currentState!.validate()) {
      UserModel user = UserModel(
          uid: null,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          gender: gender,
          email: _emailController.text,
          phone: _phoneNumberController.text,
          userType: userType,
          profileIcon:
              'https://firebasestorage.googleapis.com/v0/b/graduate-40eb5.appspot.com/o/default-profile.jpg?alt=media&token=30b6038b-6a47-4b33-be09-b7ba5eae018a',
          level: int.tryParse(_levelController.text),
          gpa: _gpaController.text.isNotEmpty
              ? double.parse(_gpaController.text)
              : null,
          department: int.tryParse(_levelController.text) == null ||
                  int.tryParse(_levelController.text)! < 3 ||
                  userType != 'Student'
              ? null
              : department,
          password: _passwordController.text);

      try {
        await BlocProvider.of<LoginStateCubit>(context)
            .SignUpWithEmailandPassword(user: user);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
