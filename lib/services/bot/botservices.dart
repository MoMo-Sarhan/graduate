import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CohereClient {
  var history = FirebaseFirestore.instance.collection('/history');
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  CohereClient();
  final String _apiKey = 'TcZjPcNuntkBpDbSsH5M5X8N9vlSs6Mq11KoL3rd';
  final String _apiUrl = 'https://api.cohere.ai/v1';

  Future<String> chat(String message, List<String> chatHistory) async {
    final url = '$_apiUrl/chat';
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    final chatHistoryFormatted = chatHistory.map((e) {
      if (e.startsWith('You: ')) {
        return {'role': 'USER', 'message': e.substring(5)};
      } else {
        return {'role': 'CHATBOT', 'message': e.substring(5)};
      }
    }).toList();

    final body = {
      'model': 'command-r-plus',
      'prompt_truncation': 'AUTO',
      'connectors': [],
      'message': message,
      'temperature': 0.8,
      'preamble': 'Humorous, witty, and playful. Think comedy writer.',
      'chat_history': chatHistoryFormatted,
    };

    try {
      final requestBody = jsonEncode(body);
      final response =
          await http.post(Uri.parse(url), headers: headers, body: requestBody);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to get response from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error encoding JSON or sending request: $e');
      rethrow;
    }
  }

  Future<void> saveMessage(
    String chat, {
    required String message,
    required String response,
    required bool newChat,
  }) async {
    try {
      int length = 5;
      if (length > message.length) length = message.length;
      String chatName = message.substring(0, length);
      DocumentReference docRef =
          history.doc('canva').collection(_currentUser.uid).doc('chat');
      var document = await docRef.get();
      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('collections')) {
          List<dynamic> collections = data['collections'];
          collections.insert(0, chat);
          await docRef.update({'collections': collections.toSet()});
        }
      } else {
        await docRef.set({
          'collections': [chat]
        });
      }

      history
          .doc('canva')
          .collection(this._currentUser.uid)
          .doc('chat')
          .collection(newChat ? chatName : chat)
          .doc()
          .set({
        'message': message,
        'response': response,
        'time': Timestamp.now(),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<dynamic>> getChats() async {
    try {
      DocumentReference docRef =
          history.doc('canva').collection(_currentUser.uid!).doc('chat');
      var docment = await docRef.get();
      if (docment.exists) {
        Map<String, dynamic> data = docment.data() as Map<String, dynamic>;
        if (data.containsKey('collections')) {
          List<dynamic> collections = data['collections'] as List<dynamic>;
          return collections;
        }
      }
      return ['no collection found'];
    } catch (e) {
      log(e.toString());
      return ['error'];
    }
  }

  Future<List<dynamic>> getChat({required String chat}) async {
    try {
      CollectionReference collectionRef = history
          .doc('canva')
          .collection(_currentUser.uid!)
          .doc('chat')
          .collection(chat);
      QuerySnapshot snapshot =
          await collectionRef.orderBy('time', descending: true).get();
      List<dynamic> messages = snapshot.docs.map((e) => e.data()).toList();
      return messages;
    } catch (e) {
      log(e.toString());
      return ['error'];
    }
  }
}
