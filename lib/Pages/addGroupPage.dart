import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/user_model.dart';
import 'package:graduate/services/chat_services.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});
  static const String ID = 'Add Group Page';

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final _chooseIconService = ChooseIconService();
  List<UserModel> selectedUsers = [];
  @override
  Widget build(BuildContext context) {
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
        Expanded(child: _buildUserList())
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildUserItem(UserModel friend) {
    final isSelected = selectedUsers.contains(friend);
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
}
