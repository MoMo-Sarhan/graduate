import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/component/CustomInputFiled.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/community_services.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});
  // ignore: constant_identifier_names
  static const String ID = 'AddPostPage';
  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _contentConroller = TextEditingController();
  String? imagePath;
  String content = 'hello world';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (content.isNotEmpty || imagePath != null) {
                String userUid = FirebaseAuth.instance.currentUser!.uid;
                String? imageUrl;
                UserModel user =
                    BlocProvider.of<LoginStateCubit>(context).userModel!;
                if (imagePath != null) {
                  imageUrl = await uploadImage(imagePath!);
                }
                PostCardModel post = PostCardModel(
                  userName: user.getFullName(),
                  userUid: userUid,
                  time: Timestamp.now(),
                  content: content,
                  imagePath: imageUrl,
                  likes: 0,
                  postId: '',
                  commentNum: 0,
                  commentsList: [],
                  file: '',
                  likesList: [],
                  ifIsLiked: false,
                  // file: ,
                );
                _contentConroller.clear();
                await CommunityServices().addPost(post: post, user: user);
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.check,
            ),
            iconSize: 30,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    children: [
                      Container(
                        child: Text(content),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                            image: imagePath == null
                                ? null
                                : DecorationImage(
                                    image: FileImage(
                                      File(imagePath!),
                                    ),
                                    fit: BoxFit.fill)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: ListView(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await chooseImage(fromCamera: false);
                      },
                      icon: const Icon(Icons.image),
                    ),
                    IconButton(
                      onPressed: () async {
                        await chooseImage(fromCamera: true);
                      },
                      icon: const Icon(Icons.camera_enhance),
                    ),
                    IconButton(
                        onPressed: () {
                          //TODO - implementation of upload file
                        },
                        icon: const Icon(Icons.file_upload))
                  ],
                ),
              )
            ]),
          ),
          CustomMessageFiled(
            messageController: _contentConroller,
            onPressed: () async {
              if (content.isNotEmpty || imagePath != null) {
                String userUid = FirebaseAuth.instance.currentUser!.uid;
                String? imageUrl;
                UserModel user =
                    BlocProvider.of<LoginStateCubit>(context).userModel!;
                if (imagePath != null) {
                  imageUrl = await uploadImage(imagePath!);
                }
                PostCardModel post = PostCardModel(
                  userName: user.getFullName(),
                  userUid: userUid,
                  time: Timestamp.now(),
                  content: content,
                  imagePath: imageUrl,
                  likes: 0,
                  postId: '',
                  commentNum: 0,
                  commentsList: [],
                  file: '',
                  likesList: [],
                  ifIsLiked: false,
                  // file: ,
                );
                _contentConroller.clear();
                await CommunityServices().addPost(post: post, user: user);
                Navigator.pop(context);
              }
            },
            onChange: (value) {
              setState(() {
                content = value;
              });
            },
          )
        ],
      ),
    );
  }

  // load image
  Future<void> chooseImage({required bool fromCamera}) async {
    XFile? pickedFile;
    if (fromCamera) {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      // You can now upload the picked image to Firebase Storage
      setState(() {
        imagePath = pickedFile?.path ?? '';
      });
      log(imagePath ?? 'not loading image');
    }
  }

  Future<String?> uploadImage(String filePath) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String imageName = filePath.split('/').last;

    if (user != null) {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_post_image/${user.uid}/$imageName');

      try {
        await storageRef.putFile(File(filePath));
        log('Image uploaded successfully');
        return await storageRef.getDownloadURL();
      } catch (e) {
        log('Error uploading image: $e');
        return null;
      }
    }
    return null;
  }
}
