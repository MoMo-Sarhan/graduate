import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduate/component/CustomButton.dart';
import 'package:graduate/component/custom_text_filed.dart';
import 'package:graduate/component/dropDownGender.dart';
import 'package:graduate/helper/constatn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static const String ID = 'Register Page';
  GlobalKey<FormState> formKey = GlobalKey();

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
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _gpaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  bool isChecked = false;
  bool showPassWord = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: widget.formKey,
      child: Column(
        children: [
          SafeArea(
            child: Image.asset(
              kCollegeIcon,
              height: 100,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 50,
                ),
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
                CustomDropDown(
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
                CustomDropDown(
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
                        validator: (value) {
                          double x;
                          try {
                            x = double.parse(value);
                          } on FormatException catch (e) {
                            return 'Enter right gpa';
                          }

                          if (x == null || x < 0 || x > 4) {
                            return 'Enter  GPA between 0 and 4';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          int x;
                          try {
                            x = int.parse(value);
                          } on FormatException catch (e) {
                            return 'Enter level';
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
                  controller: _lastNameController,
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
            formKey: widget.formKey,
          )
        ],
      ),
    ));
  }
}
