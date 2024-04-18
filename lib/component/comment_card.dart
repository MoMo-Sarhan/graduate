// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/comment_model.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';

class CommentCard extends StatefulWidget {
  CommentCard({
    required this.comment,
    required this.post,
  });
  CommentModel comment;
  PostCardModel post;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  TextEditingController _commentContent = TextEditingController();
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
            trailing: PopupMenuButton(
              onSelected: (value) async {
                if (value == 'edit') {
                  try {
                    await editComment();
                  } catch (e) {}
                }
                if (value == 'delete') {
                  try {
                    await deleteComment();

                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                          return AlertDialog(
                            content: Text('Delete succesuly'),
                          );
                        });
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                          return AlertDialog(
                            content: Text(e.toString()),
                          );
                        });
                  }
                }
              },
              position: PopupMenuPosition.under,
              itemBuilder: (context) => const [
                PopupMenuItem(
                    height: 1, value: 'delete', child: Text('delete')),
                PopupMenuItem(height: 1, value: 'edit', child: Text('edit')),
              ],
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

  Future<void> deleteComment() async {
    UserModel currentUser =
        BlocProvider.of<LoginStateCubit>(context).userModel!;

    var comment = FirebaseFirestore.instance
        .collection(widget.post.collection!)
        .doc(widget.post.postId)
        .collection('comments')
        .doc(widget.comment.id);
    var commentdata = CommentModel.fromDoc(await comment.get());
    if (commentdata.uid == currentUser.uid) {
      await comment.delete();
    } else {
      throw Exception('you are not the owner of the comment');
    }
  }

  Future<void> editComment() async {
    UserModel currentUser =
        BlocProvider.of<LoginStateCubit>(context).userModel!;

    var comment = FirebaseFirestore.instance
        .collection(widget.post.collection!)
        .doc(widget.post.postId)
        .collection('comments')
        .doc(widget.comment.id);
    var commentdata = CommentModel.fromDoc(await comment.get());
    _commentContent.text = commentdata.content;
    if (commentdata.uid == currentUser.uid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: TextField(
                controller: _commentContent,
                onSubmitted: (value) async {
                  commentdata.content = value;
                  await comment.update(commentdata.toMap());
                  Navigator.pop(context);
                },
              ),
            );
          });
    } else {
      throw Exception('you are not the owner of the comment');
    }
  }
}
