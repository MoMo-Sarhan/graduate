import 'package:flutter/material.dart';

import 'add_post.dart';
import 'comments_page.dart';

class PostPage extends StatelessWidget {
  final List<Map<String, dynamic>> posts = [
    {
      'author': 'Mohamed Adel',
      'content': 'Hello World',
      'time': '3:55 PM',
      'imageUrl': 'https://via.placeholder.com/150'
    },
    {
      'author': 'Yousef Ali',
      'content': 'Project discussion schedule attached.',
      'time': '0:54 AM',
      'imageUrl': 'https://via.placeholder.com/300x200'
    },
  ];

  PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4 CS'),
        actions: [
          IconButton(
            icon: Image.asset('assets/plus.png', width: 30, height: 30),
            onPressed: () {
              // Navigate to Add Post Screen
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreatePostPage();
              }));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(
            author: posts[index]['author']!,
            content: posts[index]['content']!,
            time: posts[index]['time']!,
            imageUrl: posts[index]['imageUrl'],
          );
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String author;
  final String content;
  final String time;
  final String? imageUrl;

  const PostCard({
    super.key,
    required this.author,
    required this.content,
    required this.time,
    this.imageUrl,
  });

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
                  CircleAvatar(
                    child: Text(author[0]),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(fontSize: 14),
              ),
              if (imageUrl != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(imageUrl!),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.thumb_up, size: 20),
                  const SizedBox(width: 5),
                  const Text('3'),
                  const SizedBox(width: 20),
                  GestureDetector(
                      onTap: () {
                        // Navigate to Comments Page
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CommentsScreen();
                        }));
                      },
                      child: const Icon(Icons.comment, size: 20)),
                  const SizedBox(width: 5),
                  const Text('4'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
