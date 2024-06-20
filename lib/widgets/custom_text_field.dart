import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({

    super.key,
    required this.label,
    required this.icon,
    required this.visibilityIcon,
    required this.controller,
    required this.validFunc,
  });
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String?Function(dynamic)? validFunc;

  final bool visibilityIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validFunc,
      controller: widget.controller,
      obscureText: widget.visibilityIcon ? _isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: widget.label,
        fillColor: Colors.white
            .withOpacity(0.2), // Slightly transparent background for text field
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.black,
        ),
        suffixIcon: widget.visibilityIcon
            ? IconButton(
                icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),

      style: const TextStyle(color: Colors.black), // Text color
    );
  }
}
