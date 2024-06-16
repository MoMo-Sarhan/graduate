import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/addGroupPage.dart';
import 'package:graduate/component/CustomInputFiled.dart';
import 'package:graduate/component/MessageContainer.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/group_model.dart';
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
  final _chatService = ChatServices();
  String pageTitle = 'Me';
  bool isGroup = false;
  String? reciverId = FirebaseAuth.instance.currentUser?.uid;
  final List<Item> _data = List<Item>.generate(
    3,
    (int index) => Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    ),
  );
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
            if (!isGroup) _drawerImage(),

            if (!isGroup) _buildUserInfo(),
            // ExpansionPanelList(
            //   expansionCallback: (index, isExpanded) {
            //     setState(() {
            //       _data[index].isExpanded = !isExpanded;
            //     });
            //   },
            //   children: _data.map<ExpansionPanel>((item) {
            //     return ExpansionPanel(
            //         headerBuilder: (BuildContext context, bool isExpanded) {
            //           return ListTile(
            //             title: Text(item.headerValue),
            //           );
            //         },
            //         body: ListTile(
            //           title: Text(item.expandedValue),
            //           subtitle: Text("To delete this panedl "),
            //           trailing: Icon(Icons.delete),
            //           onTap: () {
            //             _data.removeWhere((currentItem) => item == currentItem);
            //           },
            //         ),
            //         isExpanded: item.isExpanded);
            //   }).toList(),
            // ),
            _buildGroups(),
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
          if (!isGroup) {
            if (_messageController.text.isNotEmpty) {
              _chatService.sendMessage(
                  reciverId ?? currentUSer.uid, _messageController.text);
              _messageController.clear();
              _listMessageController.animateTo(
                0,
                duration: const Duration(microseconds: 500),
                curve: Curves.bounceInOut,
              );
            }
          } else {
            if (_messageController.text.isNotEmpty) {
              _chatService.sendMessageToGroup(
                  groupName: reciverId!, message: _messageController.text);
              _messageController.clear();
              _listMessageController.animateTo(0,
                  duration: const Duration(microseconds: 500),
                  curve: Curves.bounceInOut);
            }
          }
        });
  }

  Widget _buildListMessage() {
    return StreamBuilder(
        stream: isGroup
            ? _chatService.getMessageFromGroup(groupName: reciverId!)
            : _chatService.getMessage(
                otherUserId:
                    reciverId ?? FirebaseAuth.instance.currentUser!.uid,
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
        return SingleChildScrollView(
          child: Expanded(
            child: ExpansionTile(
              title: Text('Groups'),
              children: snapshot.data!.docs
                  .map<Widget>(
                      (doc) => _buildGroupItem(GroupModel.fromDocs(doc)))
                  .toList(),
            ),
          ),
        );
      },
    );
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
        return SingleChildScrollView(
          child: ExpansionTile(
            title: Text('Friends'),
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserItem(UserModel.fromDocs(doc)))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildGroupItem(GroupModel group) {
    return ListTile(
      leading: Icon(Icons.people),
      title: Text(
        group.group_name,
        style: TextStyle(
            color: BlocProvider.of<ModeStateCubit>(context).mode
                ? Colors.white
                : Colors.black),
      ),
      onTap: () {
        setState(() {
          pageTitle = group.group_name;
          isGroup = true;

          reciverId = group.group_name;
        });
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
        style: TextStyle(
            color: BlocProvider.of<ModeStateCubit>(context).mode
                ? Colors.white
                : Colors.black),
      ),
      onTap: () {
        setState(() {
          pageTitle = friend.getFullName();
          isGroup = false;

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
            return const SizedBox(
              width: double.infinity,
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const SizedBox(
              width: double.infinity,
              height: 200,
              child: Center(
                child: Text("Oops something went wrong!"),
              ),
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

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = true,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
