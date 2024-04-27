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
  final _cohereClient =
      CohereClient('TcZjPcNuntkBpDbSsH5M5X8N9vlSs6Mq11KoL3rd');
  List<String> _chatHistory = [];
  final _messageControl = TextEditingController();
  final _listController = ScrollController();
  String _response = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
        title: const Text('Chatbot'),
        centerTitle: true,
      ),
      drawer: const Drawer(),
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
