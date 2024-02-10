import 'package:flutter/material.dart';




//TODO -  add a floationg button but the action of the button shoud be diffrent 
//TODO - add button to add file or folder
//TODO - add button to upload file or image

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('courses')),
    );
  }
}
