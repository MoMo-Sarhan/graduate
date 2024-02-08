import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.formKey, required this.buttonText});
  GlobalKey<FormState> formKey;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll(
                Size(MediaQuery.of(context).size.width - 150, 40)),
            backgroundColor: const MaterialStatePropertyAll(Colors.blueAccent)),
        onPressed: () {
          formKey.currentState!.validate();
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'pacifico',
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
