import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.formKey
  });
  GlobalKey<FormState>formKey;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.amber),
      child: IconButton(
          onPressed: () {
            formKey.currentState!.validate();
          },
          icon: Icon(Icons.login)),
    );
  }
}
