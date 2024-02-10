// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/component/comment_card.dart';
import 'package:graduate/models/comment_model.dart';
import 'package:graduate/models/post_card_model.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage({required this.post});
  static const String ID = 'CommentsPage';
  PostCardModel post;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      if (!postData!.data()!.containsKey('comments')) {}
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

// // ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_null_aware_operators

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

// class AddPostPage extends StatefulWidget {
//   const AddPostPage({super.key});



//   @override
//   State<AddPostPage> createState() => _AddPostPageState();
// }

// class _AddPostPageState extends State<AddPostPage> {
//   final TextEditingController _contentConroller = TextEditingController();
//   String? imagePath;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: ListView(
//         children: [
//           SizedBox(
//             height: 30,
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           CircleAvatar(
//             radius: 150,
//             backgroundColor: Colors.deepPurple,
//             child: imagePath != null ? Image.file(File(imagePath!)) : null,
//           ),
//           Center(
//             child: IconButton(
//               onPressed: chooseImage,
//               icon: Icon(
//                 Icons.add_a_photo,
//                 size: 50,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//         ],
//       ),
//     );
//   }

//   // load image
//   Future<void> chooseImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       // You can now upload the picked image to Firebase Storage
//       setState(() {
//         imagePath = pickedFile.path;
//       });
//       print(imagePath);
//     }
//   }

//   Future<void> addPost() async {
//     User currentUser = FirebaseAuth.instance.currentUser!;
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     String uid = currentUser.uid;
//     if (imagePath != null) {
//       await uploadImage(imagePath!);
//     }

//     if (_contentConroller.text.isNotEmpty) {
//       CollectionReference post = FirebaseFirestore.instance.collection('posts');
//       await post.add({
//         'userId': uid,
//         'content': _contentConroller.text,
//         'timestamp': Timestamp.now(),
//         'likes': '0',
//         'image': imagePath != null ? imagePath!.split('/').last : ''
//       });
//       Navigator.pop(context);
//     }
//   }

//   Future<void> uploadImage(String filePath) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;
//     String imageName = filePath.split('/').last;

//     if (user != null) {
//       Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('user_post_image/${user.uid}/$imageName');

//       try {
//         await storageRef.putFile(File(filePath));
//         print('Image uploaded successfully');
//       } catch (e) {
//         print('Error uploading image: $e');
//       }
//     }
//   }
// }

// // import 'package:flutter/material.dart';

// // class CommentsPage extends StatefulWidget {
// //   const CommentsPage({super.key});

// //   static const String ID = 'CommentsPage';

// //   @override
// //   State<CommentsPage> createState() => _CommentsPageState();
// // }

// // class _CommentsPageState extends State<CommentsPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold();
// //   }
// // }
