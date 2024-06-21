import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/component/CustomInputFiled.dart';
import 'package:graduate/component/MessageContainer.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/chat_services.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({super.key, required this.friend});
  final UserModel friend;

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final _chatService = ChatServices();
  final ScrollController _listMessageController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final currentUSer = FirebaseAuth.instance.currentUser!;
  bool isGroup = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: ChooseIconService()
                  .getImageByUid(uid: FirebaseAuth.instance.currentUser?.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Errror'),
                  );
                } else if (snapshot.data == null) {
                  return const Center(
                    child: Text('Null data'),
                  );
                } else {
                  return SafeArea(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.purpleAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                  child: Text(widget.friend.getFullName(),
                      style: TextStyle(fontSize: 24, color: Colors.white))),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildListMessage(),
          ),
          _buildMessageInputField()
        ],
      ),
    );
  }

  Widget _buildListMessage() {
    return StreamBuilder(
        stream: isGroup
            ? _chatService.getMessageFromGroup(groupName: '')
            : _chatService.getMessage(
                otherUserId: widget.friend.uid!,
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
    return GestureDetector(
      onLongPress: () {
        showPopupMenu(context, document);
      },
      child: MessageContainer(
        uid: null,
        message: data['message'],
        userName: data['senderEmail'].toString().split('@')[0],
        time: data['timestamp'],
        alignment: alignment,
      ),
    );
  }

  void showPopupMenu(BuildContext context, DocumentSnapshot document) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset.zero,
        Offset(overlay.size.width, overlay.size.height),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('delete'),
        ),
      ],
    ).then<void>((String? selected) async {
      if (selected == 'delete') {
        try {
          await _chatService.deleteMessage(
              document: document, userId: currentUSer.uid);
          // Handle selection
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
                return AlertDialog(
                  content: Text(e.toString().split(':').last),
                );
              });
        }
      }
    });
  }

  Widget _buildMessageInputField() {
    return CustomMessageFiled(
        onChange: (value) {},
        messageController: _messageController,
        onPressed: () async {
          if (_messageController.text.isNotEmpty) {
            _chatService.sendMessage(
                widget.friend.uid!, _messageController.text);
            _messageController.clear();
            _listMessageController.animateTo(
              0,
              duration: const Duration(microseconds: 500),
              curve: Curves.bounceInOut,
            );
          }
        });
  }
}
