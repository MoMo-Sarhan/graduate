import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduate/services/bot/greate_bot_model.dart';
import 'package:http/http.dart' as http;

class YunoApiClient extends GreateBot {
  final String baseUrl = "https://pikachu65-yuno.hf.space";
  var history = FirebaseFirestore.instance.collection('/history');
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  Future<String> predict(String userQuestion) async {
    final response = await http.post(
      Uri.parse('$baseUrl/call/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'data': [userQuestion],
      }),
    );

    if (response.statusCode == 200) {
      final eventId = jsonDecode(response.body)['event_id'];
      return await getPredictionResult(eventId);
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  Future<String> getPredictionResult(String eventId) async {
    final response = await http.get(Uri.parse('$baseUrl/call/predict/$eventId'));

    if (response.statusCode == 200) {

        String rawResponse = response.body;
        String dataLine = rawResponse
            .split('\n')
            .firstWhere((line) => line.startsWith('data:'));
        String rawData = dataLine
            .substring(6)
            .trim(); // Remove "data: " prefix and trim whitespace
        List<dynamic> dataField = jsonDecode(rawData);
        return dataField[0];
    } else {
      throw Exception('Failed to load prediction result');
    }
  }

@override
  Future<void> saveMessage(
    String chat, {
    required String message,
    required String response,
    required bool newChat,
  }) async {
    try {
      if (message.isEmpty) return;
      int length = 7;
      if (length > message.length) length = message.length;
      String chatName = message.substring(0, length);
      DocumentReference docRef =
          history.doc('yuno').collection(_currentUser.uid).doc('chat');
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
          .doc('yuno')
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
}
