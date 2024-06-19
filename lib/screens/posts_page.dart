import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/helper/get_time_formate.dart';
import 'package:graduate/models/post_card_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/screens/add_post.dart';
import 'package:graduate/screens/comments_page.dart';
import 'package:graduate/services/chooseIcons_services.dart';
import 'package:graduate/services/community_services.dart';
import 'package:graduate/widgets/background.dart';

class PostPage extends StatefulWidget {
  PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = BlocProvider.of<LoginStateCubit>(context).userModel!;
    return Scaffold(
      body: Stack(
        children: [
          const BackGround(),
          SafeArea(
            child: FutureBuilder<QuerySnapshot>(
              future: CommunityServices().getPosts(user: userModel),
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
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          post: posts[index],
                          key: ValueKey(posts[index].postId),
                        );
                      }),
                );
              },
            ),
          )
          // ListView.builder(
          //   itemCount: posts.length,
          //   itemBuilder: (context, index) {
          //     return PostCard(
          //       author: posts[index]['author']!,
          //       content: posts[index]['content']!,
          //       time: posts[index]['time']!,
          //       imageUrl: posts[index]['imageUrl'],
          //     );
          //   },
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Post Screen with a custom transition
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CreatePostPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
        },
        child: Image.asset('assets/plus.png', width: 30, height: 30),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }
}

class PostCard extends StatefulWidget {
  final PostCardModel post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;

  Future<void> _toggleLike() async {
    setState(() {
      widget.post.ifIsLiked = !widget.post.ifIsLiked!;
    });
    await addLike(postId: widget.post.postId!);
    // Handle like button action
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCircualarAvatar(),
                  const SizedBox(width: 10),
                  Text(
                    widget.post.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    getTime(widget.post.time),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.post.content,
                style: const TextStyle(fontSize: 14),
              ),
              if (widget.post.imagePath != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(widget.post.imagePath!),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: _toggleLike,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: widget.post.ifIsLiked! ? 25 : 20,
                      height: widget.post.ifIsLiked! ? 25 : 20,
                      child: Image(
                        image: AssetImage('assets/like.png'),
                        color: widget.post.ifIsLiked!
                            ? Colors.purple
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(widget.post.likes.toString()),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Comments Page
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CommentsScreen();
                      }));
                    },
                    child: Image.asset(
                      'assets/chat.png',
                      width: 20,
                      height: 20,
                    ),
                    // Image.asset('assets/chat.png', width: 20, height: 20),
                  ),
                  const SizedBox(width: 5),
                  Text(widget.post.commentNum.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> addLike({required String postId}) async {
    if (widget.post.ifIsLiked!) {
      widget.post.likes += 1;
    } else {
      widget.post.likes -= 1;
    }
    setState(() {});
    _isLiked = !_isLiked;
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
}
