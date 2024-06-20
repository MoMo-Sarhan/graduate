import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _isRememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isRememberMeChecked,
      onChanged: (bool? newValue) {
        setState(() => _isRememberMeChecked = newValue!);
      },
      activeColor: Colors.blue,
      checkColor: Colors.white,
    );
  }
}
