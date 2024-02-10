import 'package:flutter/material.dart';

class SettingModel {
  SettingModel(
      {required this.text, required this.icon_1, required this.icon_2,required this.onpressed});
  String text;
  IconData icon_1;
  IconData icon_2;
  Function() onpressed;
}
