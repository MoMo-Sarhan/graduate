import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/component/PostCard.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/helper/constatn.dart';
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
  final StreamController _controller = StreamController<int>();
  List<int> dataList = [];

  @override
  Widget build(BuildContext context) {
    UserModel userModel = BlocProvider.of<LoginStateCubit>(context).userModel!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${userModel.level} ${userModel.department}'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
            iconSize: 24,
          ),
          IconButton(
            onPressed: () {},
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
            posts.add(PostCardModel.fromDoc(doc: doc, postId: doc.id));
          }
          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          UserModel? user = await UserServices()
              .getStudentData(uid: FirebaseAuth.instance.currentUser!.uid);
          log(FirebaseAuth.instance.currentUser!.uid);
          await CommunityServices().addPost(
              user: user,
              post: PostCardModel(
                  userUid: FirebaseAuth.instance.currentUser!.uid,
                  time: Timestamp.now(),
                  content: 'mohamed sarhan',
                  likes: 0,
                  postId: '',
                  ifIsLiked: true,
                  commentNum: 0,
                  commentsList: [],
                  likesList: []));
        },
        child: const Icon(
          Icons.chat,
          size: 37,
        ),
      ),
    );
  }
}
