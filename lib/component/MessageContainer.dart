// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class MessageContainer extends StatelessWidget {
  MessageContainer({
    super.key,
    required this.uid,
    required this.message,
    required this.userName,
    required this.alignment,
    required this.time,
  });
  final String? uid;
  final String userName;
  final String message;
  final bool alignment;
  final Timestamp time;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            alignment ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (uid != null && !alignment) _buildCircualarAvatar(uid: uid),
          Column(
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
                      ? Colors.grey
                      : Color.fromARGB(255, 131, 129, 129),
                ),
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
                              style: TextStyle(
                                  color:
                                      BlocProvider.of<ModeStateCubit>(context)
                                              .mode
                                          ? Colors.black
                                          : Colors.white),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ],
          ),
          if (uid != null && alignment) _buildCircualarAvatar(uid: uid),
        ],
      ),
    );
  }

  Widget _buildCircualarAvatar({required String? uid}) {
    return FutureBuilder(
      future: ChooseIconService().getImageByUid(uid: uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        }
        return CircleAvatar(backgroundImage: NetworkImage(snapshot.data!));
      },
    );
  }
}
