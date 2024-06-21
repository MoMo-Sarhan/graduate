import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graduate/models/group_model.dart';
import 'package:graduate/models/message_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String reciverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
        message: message,
        reciverId: reciverId,
        senderId: currentUserId,
        timestamp: timestamp);

    List<String> ids = [currentUserId, reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firebaseFirestore
        .collection(
          'chat_rooms',
        )
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(
      {required String userId, required String otherUserId}) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteMessage(
      {required DocumentSnapshot document, required String userId}) async {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    MessageModel message = MessageModel.fromDoc(data);
    if (message.senderId == userId) {
      await document.reference.delete();
    } else {
      throw Exception('not permitted for you');
    }
  }

  Stream<QuerySnapshot> getFriends({required UserModel user}) {
    String collection = 'users';
    log(user.email);
    return FirebaseFirestore.instance
        .collection(collection)
        .where('userType', isEqualTo: user.userType)
        .where('level', isEqualTo: user.level)
        .where('department', isEqualTo: user.department)
        // .where('email', isNotEqualTo: user.email)
        .snapshots();
  }

  Stream<QuerySnapshot> getGroups({required UserModel user}) {
    String collection = 'groups';
    return FirebaseFirestore.instance
        .collection(collection)
        .where('level', isEqualTo: user.level)
        .where('departement', isEqualTo: user.department)
        .snapshots();
  }

  Future<String?> pickImage({required bool fromCam}) async {
    XFile? pickedFile;
    if (fromCam) {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      // You can now upload the picked image to Firebase Storage
      String imagePath = pickedFile.path;
      return imagePath;
    }
    return null;
  }

  Future<void> uploadImage({File? filePath, String? groupName}) async {
    if (filePath == null || groupName == null) return;
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('group/$groupName/group_image.jpg');

    try {
      if (groupName == null) throw Exception('the group name is empty');
      await storageRef.putFile(filePath);
      log('Image uploaded successfully');
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  Future<String>? getGroupImage({required GroupModel group}) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('group/${group.group_name}/group_image.jpg');
    try {
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      log('Error getting group ${group.getFullName()} image URL: $e');
      // Return a default image URL or handle the error as needed
      return 'https://via.placeholder.com/150';
    }
  }

  Future<void> sendMessageToGroup(
      {required String groupName, required String message}) async {
    String collection = 'groups';
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(collection).doc(groupName);
    DocumentSnapshot dataOfDoc = await docRef.get();
    GroupModel group = GroupModel.fromDocs(dataOfDoc);
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    if (!group.permissions) throw Exception('send in this group is not allowed');
    if (group.member_ids.contains(currentUserId)) {
      final Timestamp timestamp = Timestamp.now();

      MessageModel newMessage = MessageModel(
          message: message,
          reciverId: groupName,
          senderId: currentUserId,
          timestamp: timestamp);

      await docRef.collection('messages').add(newMessage.toMap());
    } else {
      throw Exception('you are not a member of that group');
    }
  }

  Future<void> create_group({required GroupModel group}) async {
    try {
      await _firebaseFirestore
          .collection('/groups')
          .doc(group.group_name)
          .set(group.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<QuerySnapshot> getMessageFromGroup({required String groupName}) {
    String collection = 'groups';
    return _firebaseFirestore
        .collection(collection)
        .doc(groupName)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
