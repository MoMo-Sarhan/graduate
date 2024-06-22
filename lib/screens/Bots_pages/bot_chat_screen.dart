import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:graduate/services/bot/coher_bot_servces.dart';

class CoherScreen extends StatefulWidget {
  const CoherScreen({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
  });
  final String icon;
  final String name;
  final String description;

  @override
  _CoherScreenState createState() => _CoherScreenState();
}

class _CoherScreenState extends State<CoherScreen> {
  final List<Map<String, String>> messages = [
    {
      'sender': 'bot',
      'text': 'Hello! How can I help you today?',
      'displayedText': 'Hello! How can I help you today?',
    },
    // Add more initial messages here if needed
  ];

  final _cohereClient = CohereClient();
  List<String> _chatHistory = [];
  final TextEditingController _messageControl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  final _listController = ScrollController();
  String _response = '';
  String _chat = '';

  @override
  void initState() {
    super.initState();
    // Add a small delay before starting the typing animation for the description
    Future.delayed(const Duration(milliseconds: 500), () {
      _simulateBotResponse(widget.description);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageControl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageControl.text;
    _messageControl.clear();

    setState(() {
      _chatHistory.insert(0, 'You: $message');
    });

    try {
      final response = await _cohereClient.chat(message, _chatHistory);
      final botResponse = jsonDecode(response)['text'];

      setState(() {
        _response = botResponse;
        _chatHistory.insert(0, 'Bot: $_response');
        // _chatHistory.add('You: $message');
        // _chatHistory.add('Bot: $_response');
      });

      _listController.animateTo(
        0,
        duration: const Duration(microseconds: 500),
        curve: Curves.bounceInOut,
      );
      _chat = _chatHistory.length == 2 ? message.substring(0, 5) : _chat;
      await _cohereClient.saveMessage(_chat,
          message: message,
          response: jsonDecode(response)['text'],
          newChat: _chatHistory.length == 2);
      var x = await _cohereClient.getChats();
      log(x.toString());
    } catch (e) {
      log('Error: $e');
      log('$_chatHistory');

      setState(() {
        _response = 'Oops! Something went wrong. Please try again.$e';
        _chatHistory.insert(0, 'Bot: $_response');
      });
    }
  }

  // void _sendMessage() {
  //   final text = _controller.text.trim();
  //   if (text.isNotEmpty) {
  //     setState(() {
  //       messages.add({'sender': 'user', 'text': text, 'displayedText': text});
  //       _controller.clear();
  //       _simulateBotResponse('You said: $text');
  //       _scrollToBottom();
  //     });
  //   }
  // }
  void _simulateBotResponse(String responseText) {
    final response = {
      'sender': 'bot',
      'text': responseText,
      'displayedText': ''
    };
    setState(() {
      messages.add(response);
    });
    int currentIndex = messages.length - 1;

    int charIndex = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (charIndex < responseText.length) {
        setState(() {
          messages[currentIndex]['displayedText'] = messages[currentIndex]
                  ['displayedText']! +
              responseText[charIndex];
        });
        charIndex++;
        _scrollToBottom();
      } else {
        timer.cancel();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _chatHistory.clear();
                });
              },
              icon: Icon(
                Icons.add,
                size: 30,
              ))
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
                tag: widget.icon,
                child: Image.asset(widget.icon, width: 20, height: 20)),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: _cohereClient.getChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text('error'),
              );
            }
            return Column(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _chatHistory.clear();
                      });
                    },
                    child: const Text('New Chat')),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${snapshot.data![index]}'),
                        onTap: () async {
                          _chat = snapshot.data![index];
                          final history =
                              await _cohereClient.getChat(chat: _chat);
                          _chatHistory.clear();
                          history.forEach((e) {
                            String message = e['message'];
                            String response = e['response'];
                            _chatHistory.add('Bot: $response');
                            _chatHistory.add('You: $message');
                          });
                          log(history.toString());
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _listController,
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                var message = _chatHistory[index];
                final isBot = message.startsWith('Bot:');
                message = message.substring(5);
                return Container(
                  alignment:
                      isBot ? Alignment.centerLeft : Alignment.centerRight,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      if (isBot)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(widget.icon,
                              width: 20, height: 20), // Bot icon
                        ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isBot ? Colors.purple[50] : Colors.purple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Text(
                            message,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                // var message = _chatHistory[index];
                // final isUserMessage = message.startsWith('You: ');
                // final isBot = message.startsWith('Bot: ');
                // message = message.substring(5);

                // return MessageContainer(
                //     message: message,
                //     userName: '',
                //     alignment: isUserMessage,
                //     time: Timestamp.now());
              },
            ),
            // ListView.builder(
            //   controller: _scrollController,
            //   itemCount: messages.length,
            //   itemBuilder: (context, index) {
            //     final message = messages[index];
            //     final isBot = message['sender'] == 'bot';
            //     return Container(
            //       alignment:
            //           isBot ? Alignment.centerLeft : Alignment.centerRight,
            //       padding: const EdgeInsets.all(8.0),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           if (isBot)
            //             Padding(
            //               padding: const EdgeInsets.only(right: 8.0),
            //               child: Image.asset(widget.icon,
            //                   width: 20, height: 20), // Bot icon
            //             ),
            //           Flexible(
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 color:
            //                     isBot ? Colors.purple[50] : Colors.purple[100],
            //                 borderRadius: BorderRadius.circular(12),
            //               ),
            //               padding: const EdgeInsets.symmetric(
            //                   vertical: 10, horizontal: 16),
            //               child: Text(
            //                 message['displayedText']!,
            //                 style: const TextStyle(color: Colors.black),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageControl,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
