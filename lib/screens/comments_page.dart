import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/comment_model.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class CommentsScreen extends StatefulWidget {
  CommentsScreen({super.key, required this.post});
  final PostCardModel post;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildCommentsList(),

              // ListView.builder(
              //   itemCount: comments.length,
              //   itemBuilder: (context, index) {
              //     // Check if the data is of the expected type
              //     final commentData = comments[index];
              //     final replies = commentData['replies'];
              //     if (replies is List) {
              // return CommentCard(
              //         username: commentData['username'] ?? '',
              //         comment: commentData['comment'] ?? '',
              //         time: commentData['time'] ?? '',
              //         replies: replies.cast<Map<String, dynamic>>(),
              //       );
              //     }
              //     return const SizedBox
              //         .shrink(); // Empty widget for invalid data
              //   },
              // ),
            ),
            CommentInputField(post: widget.post),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Stream<QuerySnapshot> getComments() {
    return FirebaseFirestore.instance
        .collection(widget.post.collection!)
        .doc(widget.post.postId)
        .collection('comments')
        .orderBy('timestamp')
        .snapshots();
  }

  Widget _buildCommentsList() {
    return StreamBuilder(
        stream: getComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return const Center(
              child: Text('Error'),
            );
          }
          List<CommentModel> comments = [];
          for (var doc in snapshot.data!.docs) {
            comments.add(CommentModel.fromDoc(doc));
            comments.last.id = doc.id;
          }
          return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  comment: comments[index],
                  post: widget.post,
                );
              });
        });
  }
}

class CommentInputField extends StatefulWidget {
  CommentInputField({
    super.key,
    required this.post,
  });
  final PostCardModel post;

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: addComment,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addComment() async {
    log('pressed');
    UserModel currentUser =
        BlocProvider.of<LoginStateCubit>(context).userModel!;
    log('2');
    if (_commentController.text.isNotEmpty) {
      var selectedPost = FirebaseFirestore.instance
          .collection(widget.post.collection!)
          .doc(widget.post.postId);
      var postData = await selectedPost.get();
      int numComment = postData['commentNum'];
      numComment++;
      await selectedPost.update({
        'commentNum': numComment,
      });
      log('2');
      if (!postData.data()!.containsKey('comments')) {}
      selectedPost.collection('comments').add({
        'uid': currentUser.uid,
        'userName': currentUser.getFullName(),
        'content': _commentController.text,
        'timestamp': Timestamp.now()
      });
      _commentController.clear();
      log('done');
    }
    log('2');
  }
}

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final PostCardModel post;

  const CommentCard({
    super.key,
    required this.comment,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCircualarAvatar(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      comment.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Text(
                    getTime(post.time),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                comment.content,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.thumb_up, size: 18),
                    label: const Text('Like'),
                    onPressed: () {
                      // Handle Like action
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.reply, size: 18),
                    label: const Text('Reply'),
                    onPressed: () {
                      // Handle Reply action
                    },
                  ),
                ],
              ),
              // if (replies.isNotEmpty) ...[
              //   Padding(
              //     padding: const EdgeInsets.only(left: 40),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: replies.map((reply) {
              //         return CommentCard(
              //           username: reply['username'] ?? '',
              //           comment: reply['comment'] ?? '',
              //           time: reply['time'] ?? '',
              //           replies: const [],
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircualarAvatar() {
    return FutureBuilder(
      future: ChooseIconService().getImageByUid(uid: post.userUid),
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
