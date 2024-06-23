import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/user_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CourseService {
  final Reference storgeRef = FirebaseStorage.instance.ref();

  Future<List<Reference>?> getLevelDirs(
      {required BuildContext context, required String link}) async {
    UserModel? user = BlocProvider.of<LoginStateCubit>(context).userModel;
    if (user == null) {
      return [];
    }
    String passlink = 'courses/level_${user.level}/${user.department}';
    if (link.isNotEmpty) {
      passlink = link;
    }
    if (passlink.endsWith('.pdf')) {
      var parts = passlink.split('/');
      parts.removeLast();
      passlink = parts.join('/');
    }

    try {
      ListResult content = await storgeRef.child(passlink).listAll();
      return content.prefixes + content.items;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> downloadFile({required Reference ref}) async {
    try {
      // Get the external storage directory
      Directory? externalDir = await getExternalStorageDirectory();

      // Check if the external storage directory is available
      if (externalDir == null) {
        print('Error: External storage directory not available');
        return;
      }

      // Define the main directory for your app
      String mainDirectoryPath = '${externalDir.path}/YourApp';

      // Create the main directory if it doesn't exist
      Directory mainDirectory = Directory(mainDirectoryPath);
      if (!mainDirectory.existsSync()) {
        mainDirectory.createSync(recursive: true);
      }

      // Define the path where the file will be saved
      String filePath = '$mainDirectoryPath/${ref.name}';

      // Get download URL from Firebase Storage reference
      String downloadURL = await ref.getDownloadURL();

      // Download the file using Dio package
      await Dio().download(
        downloadURL,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            print(
                'Downloaded ${((receivedBytes / totalBytes) * 100).toStringAsFixed(0)}%');
          }
        },
      );

      print('File downloaded to: $filePath');

      // Open the downloaded file
      await OpenFile.open(filePath);
    } catch (e) {
      log('Error downloading file: $e');
    }
  }

  Future<void> creatCourse(
      {required String link, required BuildContext context}) async {
    UserModel user = BlocProvider.of<LoginStateCubit>(context).userModel!;
    if (link.isEmpty) link = 'courses/level_${user.level}/${user.department}';

    TextEditingController courseNameController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: courseNameController,
              onSubmitted: (value) async {
                try {
                  await storgeRef
                      .child('$link/${courseNameController.text}')
                      .putString('');
                  log('Created suddfafy');
                } catch (e) {
                  log(e.toString());
                }
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  Future<List<String?>?> pickFile(
      {required BuildContext context, required String link}) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      // You can now upload the picked image to Firebase Storage
      List<String?> filePath = pickedFile.paths;
      filePath.forEach((element) {
        log(element.toString());
      });
      await uploadFiles(filePath: filePath, context: context, link: link);
      return filePath;
    }
    return null;
  }

  Future<void> uploadFiles(
      {required List<String?> filePath,
      required BuildContext context,
      required String link}) async {
    UserModel user = BlocProvider.of<LoginStateCubit>(context).userModel!;
    if (link.isEmpty) link = 'courses/level_${user.level}/${user.department}';
    log(link);
    for (var file in filePath) {
      if (file != null) {
        try {
          link = '$link/${file.split('/').last}';
          log(link);
          await storgeRef.child(link).putFile(File(file));
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
                return AlertDialog(
                  content: Text('Upload Successufly'),
                );
              });
          log('Done');
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
                return AlertDialog(
                  content: Text('Error While Uploading'),
                );
              });
          log('Error uploading File: $e');
        }
      }
    }
  }

  Future<void> delete(
      {required String link, required BuildContext context}) async {
    UserModel user = BlocProvider.of<LoginStateCubit>(context).userModel!;
    if (link.isEmpty) link = 'courses/level_${user.level}/${user.department}';
    try {
      await storgeRef.child(link).delete();
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
            return AlertDialog(
              content: Text('Delete succesuly'),
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
            return AlertDialog(
              content: Text('Error While Deleteing:${e.toString()}'),
            );
          });
    }
  }
}
