// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors
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
      color: const Color.fromARGB(255, 117, 116, 116),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: Colors.grey,
            // leading: CircleAvatar(
            //   // You can replace this with user profile image

            //   backgroundImage:NetworkImage(widget.comment.userIcon) ,            ),
            title: Text(
                widget.comment.userName), // Replace with the post author's name
            subtitle: Text(
              getTime(widget.comment.time),
              style: TextStyle(color: Colors.white),
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
