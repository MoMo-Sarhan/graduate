import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/component/CustomInputFiled.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';

class BotPage extends StatefulWidget {
  const BotPage({super.key});

  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
        title: Text('Chatbot'),
        centerTitle: true,
      ),
      drawer: Drawer(),
      body: Stack(
        children: [
          Center(
              child: Image(
            color: BlocProvider.of<ModeStateCubit>(context).mode
                ? Colors.white
                : Colors.black,
            image: AssetImage('assets/icons/chatbot.png'),
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 10,
          )),
          Column(children: [
            Expanded(
              child: ListView(
                children: [],
              ),
            ),
            CustomMessageFiled(
              messageController: messageController,
              onPressed: () {},
              onChange: (value) {},
            )
          ]),
        ],
      ),
    );
  }
}
