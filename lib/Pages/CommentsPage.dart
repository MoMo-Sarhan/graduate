// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduate/component/comment_card.dart';
import 'package:graduate/models/comment_model.dart';
import 'package:graduate/models/post_card_model.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({required this.post});
  static const String ID = 'CommentsPage';
  final PostCardModel post;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 203, 203),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 204, 203, 203),
        title: Text('Comments'),
        centerTitle: true,
      ),
      body: Column(children: [
        // adding list builder
        // adding new comment
        Expanded(child: _buildCommentsList()),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  obscureText: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                          onPressed: addComment,
                          icon: Icon(
                            Icons.send,
                            size: 40,
                            color: Colors.blue,
                          ))),
                ),
              ),
            ),
          ],
        )
      ]),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Error'),
            );
          }
          List<CommentModel> comments = [];
          for (var doc in snapshot.data!.docs) {
            comments.add(CommentModel.fromDoc(doc));
          }
          return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentCard(comment: comments[index]);
              });
        });
  }

  Future<void> addComment() async {
    setState(() {});
    if (_controller.text.isNotEmpty) {
      var selectedPost = FirebaseFirestore.instance
          .collection(widget.post.collection!)
          .doc(widget.post.postId);
      var postData = await selectedPost.get();
      int numComment = postData['commentNum'];
      numComment++;
      await selectedPost.update({
        'commentNum': numComment,
      });
      if (!postData.data()!.containsKey('comments')) {}
      selectedPost.collection('comments').add({
        'uid': widget.post.userUid,
        'userName': widget.post.userName,
        'content': _controller.text,
        'timestamp': Timestamp.now()
      });
      _controller.clear();
    }
  }
}
