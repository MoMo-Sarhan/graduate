import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/component/CustomInputFiled.dart';
import 'package:graduate/component/MessageContainer.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/services/bot/botservices.dart';

class BotPage extends StatefulWidget {
  const BotPage({super.key});

  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  final TextEditingController messageController = TextEditingController();
  final _cohereClient = CohereClient();
  List<String> _chatHistory = [];
  final _messageControl = TextEditingController();
  final _listController = ScrollController();
  String _response = '';
  String _chat = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: _cohereClient.getChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return Center(
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
                    child: Text('New Chat')),
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
                            _chatHistory.add('Bot: $_response');
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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
        title: const Text('Chatbot'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
              child: Image(
            color: BlocProvider.of<ModeStateCubit>(context).mode
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/icons/chatbot.png'),
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 10,
          )),
          Column(children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                controller: _listController,
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  var message = _chatHistory[index];
                  final isUserMessage = message.startsWith('You: ');
                  message = message.substring(5);
                  return MessageContainer(
                      message: message,
                      userName: '',
                      alignment: isUserMessage,
                      time: Timestamp.now());
                },
              ),
            ),
            CustomMessageFiled(
              messageController: _messageControl,
              onPressed: () async {
                final message = _messageControl.text;
                _messageControl.clear();

                try {
                  final response =
                      await _cohereClient.chat(message, _chatHistory);
                  final botResponse = jsonDecode(response)['text'];

                  setState(() {
                    _response = botResponse;
                    _chatHistory.insert(0, 'You: $message');
                    _chatHistory.insert(0, 'Bot: $_response');
                    // _chatHistory.add('You: $message');
                    // _chatHistory.add('Bot: $_response');
                  });

                  _listController.animateTo(
                    0,
                    duration: const Duration(microseconds: 500),
                    curve: Curves.bounceInOut,
                  );
                  _chat = _chatHistory.length == 2
                      ? message.substring(0, 5)
                      : _chat;
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
                    _response =
                        'Oops! Something went wrong. Please try again.$e';
                    _chatHistory.add('Bot: $_response');
                  });
                }
              },
              onChange: (value) {},
            )
          ]),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return ChatScreen();
      //     }));
      //   },
      // ),
    );
  }
}
