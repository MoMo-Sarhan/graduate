import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  XFile? _imageFile;
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _post() {
    // Handle the post action here
    print("Post button clicked");
  }

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
              onPressed: _isPostButtonEnabled ? _post : null,
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
              const Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Mohamed Adel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
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
                  onPressed: _pickImage,
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
