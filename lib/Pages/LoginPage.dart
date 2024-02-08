import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/RegisterPage.dart';
import 'package:graduate/component/custom_text_filed.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static const String ID = 'LoginPage';
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassWord = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpeg'), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Form(
                        key: widget.formKey,
                        child: const Center(
                            child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'pacifico'),
                        )),
                      ),
                      const Spacer(),
                      CustomTextFormFiled(
                        hintText: 'Email',
                        label: 'Email',
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Email';
                          }
                        },
                        onChange: (value) {},
                        obscureText: false,
                        isEnabled: true,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      const Spacer(),
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
                      const Spacer(
                        flex: 5,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              minimumSize:
                                  MaterialStatePropertyAll(Size(300, 40))),
                          onPressed: () async {
                            if (widget.formKey.currentState!.validate()) {
                              await BlocProvider.of<LoginStateCubit>(context)
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                            }
                          },
                          child: Text('Log In'),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterPage.ID);
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
