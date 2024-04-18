import 'dart:developer';

import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
 const CustomTextFormFiled({
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
  final String hintText;
  final String label;
  final TextEditingController controller;
  final String? Function(dynamic)? validator;
  final Function(String)? onChange;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
 final bool isEnabled;

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
