import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/chat_page.dart';
import 'package:graduate/component/PostCard.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/community_services.dart';

class SearchPostPage extends StatefulWidget {
  const SearchPostPage({super.key});
  static const String ID = 'SearchPostPage';

  @override
  State<SearchPostPage> createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  List<int> dataList = [];
  String keyWord = '';

  @override
  Widget build(BuildContext context) {
    UserModel userModel = BlocProvider.of<LoginStateCubit>(context).userModel!;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: TextField(
            onChanged: (value) {
              setState(() {
                keyWord = value;
              });
            },
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            CommunityServices().searchPost(user: userModel, keyWord: keyWord),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text('no posts founded'),
            );
          }
          List<PostCardModel> posts = [];
          for (var doc in snapshot.data!.docs) {
            bool ifisLiked = false;
            String currentUserId = FirebaseAuth.instance.currentUser!.uid;
            List<dynamic> likesList = doc['likesList'];
            if (likesList.contains(currentUserId)) ifisLiked = true;

            posts.add(PostCardModel.fromDoc(
              doc: doc,
              postId: doc.id,
              ifIsLiked: ifisLiked,
            ));
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: posts[index],
                  key: ValueKey(posts[index].postId),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ChatPage.ID);
        },
        child: const Icon(
          Icons.chat_bubble_outline_sharp,
          size: 37,
        ),
      ),
    );
  }
}
