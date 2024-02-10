// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class ChangeIconPage extends StatefulWidget {
  const ChangeIconPage({super.key});

  @override
  State<ChangeIconPage> createState() => _ChangeIconPageState();
}

class _ChangeIconPageState extends State<ChangeIconPage> {
  ChooseIconService _chooseIcon = ChooseIconService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: _chooseIcon.getUserImageUrl(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(snapshot.data!),
                ),
              );
            } else {
              return Center(child: Icon(Icons.person));
            }
          }),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                await _chooseIcon.chooseImage(fromCam: false);
                setState(() {});
              },
              icon: Icon(Icons.photo),
              iconSize: 53,
            ),
            IconButton(
              onPressed: () async {
                await _chooseIcon.chooseImage(fromCam: true);
                setState(() {});
              },
              icon: Icon(Icons.add_a_photo),
              iconSize: 50,
            ),
          ],
        ),
        // Positioned(
        //     top: MediaQuery.of(context).size.height / 2,
        //     left: MediaQuery.of(context).size.width / 2 + 60,
        //     child: IconButton(
        //         onPressed: () {
        //           setState(() {
        //             // _chooseIcon.chooseImage();
        //           });
        //         },
        //         icon: Icon(
        //           Icons.add_a_photo,
        //           size: 30,
        //           color: Colors.blue,
        //         )))
      ],
    ));
  }
}
