// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graduate/helper/get_time_formate.dart';

class MessageContainer extends StatelessWidget {
  MessageContainer({
    super.key,
    required this.message,
    required this.userName,
    required this.alignment,
    required this.time,
  });
  final String userName;
  final String message;
  final bool alignment;
  final Timestamp time;

  // String getTime() {
  //   DateTime timeData = time.toDate();
  //   int hour = timeData.hour;
  //   int second = timeData.second;
  //   int day = timeData.day;
  //   int month = timeData.month;
  //   int year = timeData.year;
  //   return '$hour:$second $day/$month/$year';
  // }

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: !alignment ? Radius.circular(20) : Radius.zero,
                  bottomLeft: alignment ? Radius.circular(20) : Radius.zero,
                ),
                color: alignment
                    ? Color.fromARGB(255, 216, 193, 126)
                    : Color.fromARGB(255, 140, 153, 228)),
            child: IntrinsicWidth(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message),
                    Row(
                      mainAxisAlignment: alignment
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Text(
                          getTime(time),
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
