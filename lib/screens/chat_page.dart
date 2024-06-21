import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/addGroupPage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/group_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/screens/bot_chat_screen.dart';
import 'package:graduate/screens/group_chat_screen.dart';
import 'package:graduate/screens/private_chat_screen.dart';
import 'package:graduate/services/chat_services.dart';
import 'package:graduate/services/chooseIcons_services.dart';
import 'package:graduate/services/user_data_services.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                onSelected: (value) {
                  if (value == 'New Group') {
                    Navigator.pushNamed(context, AddGroupPage.id);
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                        height: 1, value: 'New Group', child: Text('New Group'))
                  ];
                })
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                child: const Text('Chats',
                    style: TextStyle(fontSize: 24, color: Colors.white))),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Group Chats'),
              Tab(text: 'DM Chats'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ChatList(type: 'group'),
            ChatList(type: 'dm'),
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  final String type;

  const ChatList({super.key, required this.type});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChooseIconService _chooseIconService = ChooseIconService();
  final _chatService = ChatServices();

  @override
  Widget build(BuildContext context) {
    return widget.type == 'group' ? _buildGroups() : _buildUserList();
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getFriends(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PrivateChatScreen(friend: friend);
            }));
          },
        ),
      ),
    );
  }

  Widget _buildGroups() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getGroups(
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
              .map<Widget>((doc) => _buildGroupItem(GroupModel.fromDocs(doc)))
              .toList(),
        );
      },
    );
  }

  Widget _buildGroupItem(GroupModel group) {
    return ChatCard(
      group: group,
    );
  }
}

class ChatCard extends StatelessWidget {
  final GroupModel group;
  final ChatServices _chatservices = ChatServices();
  ChatCard({
    super.key,
    required this.group,
  });
  final String imageUrl = 'https://via.placeholder.com/150';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
              child: FutureBuilder(
            future: _chatservices.getGroupImage(group: group),
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
          // CircleAvatar(
          //   backgroundImage: NetworkImage(imageUrl),
          // ),
          title: Text(
            group.group_name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupChatScreen(
                  group: group,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
