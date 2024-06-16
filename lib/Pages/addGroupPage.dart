import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/group_model.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/chat_services.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});
  static const String id = 'Add Group Page';

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final Set<String> MembersIds = {};
  final TextEditingController _groupNameController = TextEditingController();
  final _chooseIconService = ChooseIconService();
  List<UserModel> selectedUsers = [];
  final ChatServices _chatServices = ChatServices();
  @override
  Widget build(BuildContext context) {
    UserModel me = BlocProvider.of<LoginStateCubit>(context).userModel!;
    return Scaffold(
      appBar: AppBar(title: const Text('New group')),
      body: Column(children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black.withOpacity(0.2),
            child: const Icon(Icons.camera_alt),
          ),
          title: TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              hintText: 'Group Name',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Member',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Text(
          'Friends',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Expanded(child: _buildUserList(user: me))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_groupNameController.text != null &&
              _groupNameController.text.isNotEmpty) {
            final GroupModel _group = GroupModel(
                level: me.level!,
                departement: me.department!,
                group_name: _groupNameController.text,
                admins: [me.uid!],
                member_ids: MembersIds.toList(),
                permissions: true);
            log('start creating group');
            await _chatServices.create_group(group: _group);
            log('finised creating group');
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            friend.getFullName(),
            style: TextStyle(
                color: BlocProvider.of<ModeStateCubit>(context).mode
                    ? Colors.white
                    : Colors.black),
          ),
          Checkbox(
              value: MembersIds.contains(friend.uid),
              onChanged: (bool? isSelected) {
                setState(() {
                  if (isSelected == true) {
                    MembersIds.add(friend.uid!);
                  } else {
                    MembersIds.remove(friend.uid!);
                  }
                  log(MembersIds.toString());
                });
              })
        ],
      ),
    );
  }

  Widget _buildUserList({required UserModel user}) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatServices().getFriends(user: user),
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
}
