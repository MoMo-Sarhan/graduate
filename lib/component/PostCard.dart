import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/Pages/CommentsPage.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class PostCard extends StatefulWidget {
  PostCard({super.key, required this.post});
  PostCardModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool? flage = false;

  @override
  void initState() {
    super.initState();
    flage = widget.post.ifIsLiked!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 165, 168, 170),
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
                widget.post.userName), // Replace with the post author's name
            subtitle: Text(
              getTime(widget.post.time),
              style: const TextStyle(color: Colors.amber),
            ), // Replace with post timestamp
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.post.content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (widget.post.imagePath != null &&
              widget.post.imagePath!.isNotEmpty)
            Image.network(widget.post.imagePath!),
          ButtonBar(
            children: [
              Text(widget.post.likes.toString()),
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: flage != null && flage! ? Colors.blue : Colors.black,
                ),
                onPressed: () async {
                  flage = !flage!;
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
    int newlikes = widget.post.likes;
    if (flage!) {
      newlikes = newlikes + 1;
    } else {
      newlikes = newlikes - 1;
    }
    widget.post.likes = newlikes;
    var selectedPost = FirebaseFirestore.instance
        .collection(widget.post.collection!)
        .doc(postId);
    await selectedPost.update({'likes': newlikes});

    // add the user in the likesid filed
    // get the fileds of the post
    var posts = await selectedPost.get();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (posts.data()!.containsKey('likesList')) {
      List<dynamic> likesId = posts['likesList'];
      if (!flage!) {
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
