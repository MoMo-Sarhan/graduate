// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool select_En = true;
  bool select_Ar = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6229e8),
      body: ListView(children: [
        CheckboxListTile(
            title: Text(
              'English',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: select_En ? Colors.black : Colors.grey),
            ),
            value: select_En,
            onChanged: (index) {
              setState(() {
                select_En = index!;
                select_Ar = false;
              });
            }),
        CheckboxListTile(
            title: Text(
              'Arabic',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: select_Ar ? Colors.black : Colors.grey),
            ),
            value: select_Ar,
            onChanged: (index) {
              setState(() {
                select_Ar = index!;
                select_En = false;
              });
            })
      ]),
    );
  }
}
