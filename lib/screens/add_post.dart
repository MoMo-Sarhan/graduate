import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/community_services.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  XFile? _imageFile;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        // Update the state whenever text changes
      });
    });
  }

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
        _imageFile = pickedFile;
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
  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     _imageFile = pickedFile;
  //   });
  // }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _isPostButtonEnabled =>
      _textController.text.isNotEmpty || _imageFile != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create post', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: _isPostButtonEnabled ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: _isPostButtonEnabled
                  ? () async {
                      if (_textController.text.isNotEmpty ||
                          imagePath != null) {
                        String userUid = FirebaseAuth.instance.currentUser!.uid;
                        String? imageUrl;
                        UserModel user =
                            BlocProvider.of<LoginStateCubit>(context)
                                .userModel!;
                        if (imagePath != null) {
                          imageUrl = await uploadImage(imagePath!);
                        }
                        PostCardModel post = PostCardModel(
                          userName: user.getFullName(),
                          userUid: userUid,
                          time: Timestamp.now(),
                          content: _textController.text,
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
                        _textController.clear();
                        await CommunityServices()
                            .addPost(post: post, user: user);
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none, // Remove border
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              if (_imageFile != null)
                Image.file(
                  File(_imageFile!.path),
                  height: 200,
                ),
              const SizedBox(height: 10), // Add some spacing to avoid overlap
              ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Photo/video'),
                  onPressed: () async {
                    await chooseImage(fromCamera: true);
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      return Colors.white; // Text color when enabled
                    }),
                    minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 50)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: You can adjust the shape
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.purple), // Fallback color
                    overlayColor: WidgetStateProperty.all<Color>(
                        Colors.purple.shade700.withOpacity(
                            0.8)), // Optional: You can add overlay color
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
