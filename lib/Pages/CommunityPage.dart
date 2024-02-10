import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/AddPostPage.dart';
import 'package:graduate/Pages/chat_page.dart';
import 'package:graduate/component/PostCard.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/community_services.dart';
import 'package:graduate/services/user_data_services.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<int> dataList = [];

  @override
  Widget build(BuildContext context) {
    UserModel userModel = BlocProvider.of<LoginStateCubit>(context).userModel!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(userModel.isGeneral()
            ? 'General'
            : userModel.isStudent() && userModel.level! < 2
                ? '${userModel.level}'
                : '${userModel.level} ${userModel.department}'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
            iconSize: 24,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddPostPage.ID);
            },
            icon: const Icon(Icons.add),
            iconSize: 35,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CommunityServices().getPosts(user: userModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
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
