import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/models/message_model.dart';
import 'package:graduate/models/user_model.dart';

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
}
