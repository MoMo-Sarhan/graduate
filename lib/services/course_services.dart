import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CourseService {
  final Reference Storge = FirebaseStorage.instance.ref();

  Future<List<Reference>?> getLevelDirs(
      {required BuildContext context, required String link}) async {
    UserModel user = BlocProvider.of<LoginStateCubit>(context).userModel!;
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
      ListResult content = await Storge.child(passlink).listAll();
      return content.prefixes + content.items;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> downloadFile({required Reference ref}) async {
    try {
      var status = Permission.storage.request();
      if (await status.isDenied || await status.isPermanentlyDenied) {
        await openAppSettings();
      }

      if (await status.isGranted) {
        String url = await ref.getDownloadURL();
        Directory appDocDirectory = Directory('/storage/emulated/0/Graduate');
        appDocDirectory.createSync();
        log(appDocDirectory.path);
        String recvFile = '${appDocDirectory.path}/${ref.name}';
        await Dio().download(
          url,
          recvFile,
          onReceiveProgress: (count, total) {
            log('count $count total $total');
            if (total != -1) {
              log('Downloaded: ${((count / total) * 100).toStringAsFixed(2)}%');
            }
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> creatCourse(
      {required String link, required BuildContext context}) async {
    UserModel user = BlocProvider.of<LoginStateCubit>(context).userModel!;
    if (link.isEmpty) link = 'courses/level_${user.level}/${user.department}';

    TextEditingController _courseNameController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _courseNameController,
              onSubmitted: (value) async {
                try {
                  await Storge.child('$link/${_courseNameController.text}')
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
          await Storge.child(link).putFile(File(file));
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
}
