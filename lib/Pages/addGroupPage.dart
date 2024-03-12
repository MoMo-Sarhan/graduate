import 'package:flutter/material.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});
  static const String ID = 'Add Group Page';

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
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
            decoration:const InputDecoration(hintText: 'Group Name',),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
