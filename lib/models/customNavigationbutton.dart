import 'package:flutter/material.dart';

class MyBottomBarModel {
  MyBottomBarModel({
    required this.icon,
    required this.label,
    required this.onpressed,
    required this.index,
  });
  String? label;
  IconData? icon;
  int index;
  Function() onpressed;
}
