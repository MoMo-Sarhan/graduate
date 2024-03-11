import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/CommentsPage.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/services/chooseIcons_services.dart';
import 'package:graduate/services/community_services.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post});
  final PostCardModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool? flage;

  @override
  void initState() {
    super.initState();
    // flage = widget.post.ifIsLiked!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 165, 168, 170),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: const Color.fromARGB(255, 202, 200, 200),
            leading: _buildCircualarAvatar(),
            title: Text(
              widget.post.userName,
              style: const TextStyle(color: Colors.black),
            ), // Replace with the post author's name
            subtitle: Text(
              getTime(widget.post.time),
              style: TextStyle(
                  color: BlocProvider.of<ModeStateCubit>(context).mode
                      ? Colors.black87
                      : Colors.white),
            ), // Replace with post timestamp
            trailing: PopupMenuButton<String>(
              child: const Icon(Icons.more_horiz),
              onSelected: (value) async {
                if (value == 'Delete') {
                  log(value);
                  try {
                    await CommunityServices().deletePost(
                        user: BlocProvider.of<LoginStateCubit>(context)
                            .userModel!,
                        post: widget.post);
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
                    setState(() {});
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pop(context);
                          });
                          return AlertDialog(
                            content: Text(e.toString()),
                          );
                        });
                  }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                      height: 3, value: 'Delete', child: Text('Delete'))
                ];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.post.content,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          if (widget.post.imagePath != null &&
              widget.post.imagePath!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(widget.post.imagePath!),
                          fit: BoxFit.fill))),
            ),
          ButtonBar(
            children: [
              Text(widget.post.likes.toString()),
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: widget.post.ifIsLiked != null && widget.post.ifIsLiked!
                      ? Colors.blue
                      : Colors.black,
                ),
                onPressed: () async {
                  setState(() {
                    widget.post.ifIsLiked = !widget.post.ifIsLiked!;
                  });
                  await addLike(postId: widget.post.postId!);
                  // Handle like button action
                },
              ),
              Text(widget.post.commentNum.toString()),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  // Handle comment button action
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CommentsPage(post: widget.post);
                  }));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addLike({required String postId}) async {
    if (widget.post.ifIsLiked!) {
      widget.post.likes += 1;
    } else {
      widget.post.likes -= 1;
    }
    setState(() {});
    var selectedPost = FirebaseFirestore.instance
        .collection(widget.post.collection!)
        .doc(postId);
    await selectedPost.update({'likes': widget.post.likes});

    // add the user in the likesid filed
    // get the fileds of the post
    var posts = await selectedPost.get();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (posts.data()!.containsKey('likesList')) {
      List<dynamic> likesId = posts['likesList'];
      if (!widget.post.ifIsLiked!) {
        likesId.remove(currentUserId);
      } else {
        likesId.add(currentUserId);
      }
      selectedPost.update({
        'likesList': likesId,
      });
    } else {
      selectedPost.update({
        'likesList': <dynamic>[currentUserId],
      });
    }
  }

  Widget _buildCircualarAvatar() {
    return FutureBuilder(
      future: ChooseIconService().getImageByUid(uid: widget.post.userUid),
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
