import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Group Chats'),
              Tab(text: 'DM Chats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatList(type: 'group'),
            ChatList(type: 'dm'),
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final String type;

  ChatList({super.key, required this.type});

  final List<Map<String, String>> groupChats = [
    {
      'name': 'Project Group',
      'message': 'See you tomorrow for the meeting!',
      'time': '3:55 PM',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Study Group',
      'message': 'Shared the new notes.',
      'time': '1:20 PM',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  final List<Map<String, String>> dmChats = [
    {
      'name': 'Alice',
      'message': 'Let’s catch up later.',
      'time': '2:45 PM',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Bob',
      'message': 'Can you review my code?',
      'time': '12:30 PM',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> chats = type == 'group' ? groupChats : dmChats;

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatCard(
          name: chats[index]['name']!,
          message: chats[index]['message']!,
          time: chats[index]['time']!,
          imageUrl: chats[index]['imageUrl']!,
        );
      },
    );
  }
}

class ChatCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  const ChatCard({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message),
          trailing: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            // Navigate to Chat Detail Page
          },
        ),
      ),
    );
  }
}
