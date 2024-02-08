import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormFiled extends StatelessWidget {
  CustomTextFormFiled({
    super.key,
    required this.hintText,
    required this.label,
    required this.controller,
    required this.validator,
    required this.onChange,
    required this.obscureText,
    required this.isEnabled,
    this.suffixIcon,
    this.prefixIcon,
  });
  String hintText;
  String label;
  TextEditingController controller;
  String? Function(dynamic)? validator;
  Function(String)? onChange;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obscureText;
  bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: isEnabled,
        onChanged: (data) {
          log(controller.text);
        },
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          label: Text(label),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
