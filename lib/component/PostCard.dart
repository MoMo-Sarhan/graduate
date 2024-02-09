import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/post_card_model.dart';

class PostCard extends StatefulWidget {
  PostCard({required this.post});
  PostCardModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool flage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 149, 179, 207),
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: Color.fromARGB(255, 10, 77, 139),
            leading: CircleAvatar(
                backgroundImage:const AssetImage('assets/images/bg1.jpeg')),
            title: Text(
                widget.post.userUid), // Replace with the post author's name
            subtitle: Text(
              getTime(widget.post.time),
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
              widget.post.content,
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (widget.post.imagePath != null)
            Image.network(widget.post.imagePath!),
          ButtonBar(
            children: [
              Text(widget.post.likes.toString()),
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: flage! ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    flage = !flage!;
                    // addLike();
                  });
                  // Handle like button action
                },
              ),
              Text(widget.post.commentNum.toString()),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Handle comment button action
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return CommentsPage(postId: widget.post.postId,);
                  // }));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addLike() async {
    int newlikes = widget.post.likes;
    if (flage!) {
      newlikes = newlikes + 1;
    } else {
      newlikes = newlikes - 1;
    }
    widget.post.likes = newlikes;
    var selectedPost =
        FirebaseFirestore.instance.collection('posts').doc(widget.post.postId);
    await selectedPost.update({'likes': newlikes.toString()});

    // add the user in the likesid filed
    // get the fileds of the post
    var posts = await selectedPost.get();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (posts.data()!.containsKey('likesId')) {
      List<dynamic> likesId = posts['likesId'];
      if (!flage!) {
        likesId.remove(currentUserId);
      } else {
        likesId.add(currentUserId);
      }
      selectedPost.update({
        'likesId': likesId,
      });
    } else {
      selectedPost.update({
        'likesId': <String>[currentUserId],
      });
    }
  }
}
