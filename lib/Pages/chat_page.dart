import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/component/CustomInputFiled.dart';
import 'package:graduate/component/MessageContainer.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/chat_services.dart';
import 'package:graduate/services/chooseIcons_services.dart';
import 'package:graduate/services/user_data_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static const String ID = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChooseIconService _chooseIconService = ChooseIconService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _listMessageController = ScrollController();
  final currentUSer = FirebaseAuth.instance.currentUser!;
  String pageTitle = 'Me';
  String? reciverId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _appBarImage(),
            const SizedBox(width: 10),
            Text(pageTitle),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: _buildListMessage(),
        ),
        _buildMessageInputField(),
      ]),
      drawer: Drawer(
        child: Column(
          children: [
            _drawerImage(),
            _buildUserInfo(),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return CustomMessageFiled(
      onChange: (value) {},
      messageController: _messageController,
      onPressed: () async {
        if (_messageController.text.isNotEmpty) {
          ChatServices().sendMessage(
              reciverId ?? currentUSer.uid, _messageController.text);
          _messageController.clear();
          _listMessageController.animateTo(
            0,
            duration: const Duration(microseconds: 500),
            curve: Curves.bounceInOut,
          );
        }
      },
    );
  }

  Widget _buildListMessage() {
    return StreamBuilder(
        stream: ChatServices().getMessage(
            otherUserId: reciverId ?? FirebaseAuth.instance.currentUser!.uid,
            userId: FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> messages = snapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              controller: _listMessageController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(messages[index]);
              });
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment =
        (data['senderId'] == FirebaseAuth.instance.currentUser!.uid);
    return MessageContainer(
      message: data['message'],
      userName: data['senderEmail'].toString().split('@')[0],
      time: data['timestamp'],
      alignment: alignment,
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatServices().getFriends(
          user: BlocProvider.of<LoginStateCubit>(context).userModel!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserItem(UserModel.fromDocs(doc)))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserItem(UserModel friend) {
    return ListTile(
      leading: CircleAvatar(
          child: FutureBuilder(
        future: _chooseIconService.getImageByUid(uid: friend.uid!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!),
            );
          } else {
            return const Icon(Icons.person);
          }
        },
      )),
      title: Text(
        friend.getFullName(),
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        setState(() {
          pageTitle = friend.getFullName();

          reciverId = friend.uid!;
        });
      },
    );
  }

  Widget _appBarImage() {
    return FutureBuilder(
        future: _chooseIconService.getImageByUid(
            uid: reciverId ?? FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Oops something went wrong!"),
            );
          }
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
          );
        });
  }

  Widget _drawerImage() {
    return FutureBuilder(
        future: _chooseIconService.getImageByUid(
            uid: reciverId ?? FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Oops something went wrong!"),
            );
          }
          return Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  snapshot.data!,
                ),
                fit: BoxFit.fill,
              ),
            ),
          );
        });
  }

  Widget _buildUserInfo() {
    return FutureBuilder(
        future: UserServices().getStudentData(uid: reciverId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          return Column(
            children: [
              ListTile(
                title: Center(child: Text(snapshot.data!.getFullName())),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(snapshot.data!.phone.toString()),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  snapshot.data!.email,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          );
        });
  }
}
