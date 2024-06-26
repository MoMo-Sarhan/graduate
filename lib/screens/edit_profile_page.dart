import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/services/chooseIcons_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  ChooseIconService _chooseIcon = ChooseIconService();

  void _saveProfile() {
    // Save profile changes here
    // You might want to send the data to a server or update it locally
    print('Name: ${_nameController.text}');
    print('Current Password: ${_currentPasswordController.text}');
    print('New Password: ${_newPasswordController.text}');
    // Implement your save logic
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  FutureBuilder(
                    future: ChooseIconService().getImageByUid(
                        uid: FirebaseAuth.instance.currentUser?.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Errror'),
                        );
                      } else if (snapshot.data == null) {
                        return const Center(
                          child: Text('Null data'),
                        );
                      } else {
                        return SafeArea(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(snapshot.data!),
                          ),
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      await _chooseIcon.chooseImage(fromCam: false);
                      setState(() {});
                    },
                    child: const Text('Change Profile Picture'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              // _saveProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
