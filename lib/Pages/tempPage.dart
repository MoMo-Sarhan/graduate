import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _cohereClient = CohereClient('TcZjPcNuntkBpDbSsH5M5X8N9vlSs6Mq11KoL3rd');
  final _textController = TextEditingController();
  List<String> _chatHistory = [];
  String _response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final message = _chatHistory[index];
                  final isUserMessage = message.startsWith('You: ');

                  return Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.lightBlue.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      message.substring(5),
                      style: TextStyle(
                        color: isUserMessage ? Colors.blue : Colors.black,
                      ),
                    ),
                  );
                },
                itemCount: _chatHistory.length,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        labelText: 'Enter your message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      final message = _textController.text;
                      _textController.clear();

                      try {
                        final response =
                            await _cohereClient.chat(message, _chatHistory);
                        final botResponse = jsonDecode(response)['text'];

                        setState(() {
                          _response = botResponse;
                          _chatHistory.add('You: $message');
                          _chatHistory.add('Bot: $_response');
                        });
                      } catch (e) {
                        print('Error: $e');

                        setState(() {
                          _response =
                              'Oops! Something went wrong. Please try again.';
                          _chatHistory.add('Bot: $_response');
                        });
                      }
                    },
                    child: Text('Send'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CohereClient {
  CohereClient(this._apiKey);
  final String _apiKey;
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
}
