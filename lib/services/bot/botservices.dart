import 'package:http/http.dart' as http;
import 'dart:convert';

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
