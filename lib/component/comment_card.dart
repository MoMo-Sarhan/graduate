// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/comment_model.dart';

class CommentCard extends StatefulWidget {
  CommentCard({required this.comment});
  CommentModel comment;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 149, 179, 207),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: Color.fromARGB(255, 10, 77, 139),
            // leading: CircleAvatar(
            //   // You can replace this with user profile image

            //   backgroundImage:NetworkImage(widget.comment.userIcon) ,            ),
            title: Text(
                widget.comment.userName), // Replace with the post author's name
            subtitle: Text(
              getTime(widget.comment.time),
              style: TextStyle(color: Colors.amber),
            ), // Replace with post timestamp
            trailing: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.comment.content,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
