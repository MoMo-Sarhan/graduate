import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(
        sender: 'Mido',
        text: 'hello',
        timestamp: '7:22 PM',
        imageUrl: 'https://via.placeholder.com/150'),
    Message(
        sender: 'Mido',
        text: 'hello world',
        timestamp: '7:39 PM',
        imageUrl: 'https://via.placeholder.com/150'),
    Message(
        sender: 'You',
        text: 'man',
        timestamp: '7:39 PM',
        imageUrl: 'https://via.placeholder.com/150'),
    Message(
        sender: 'Mido',
        text: 'yup',
        timestamp: '7:39 PM',
        imageUrl: 'https://via.placeholder.com/150'),
    Message(
        sender: 'Mido',
        text: 'dont know',
        timestamp: '9:20 PM',
        imageUrl: 'https://via.placeholder.com/150'),
    Message(
        sender: 'You',
        text: 'xd',
        timestamp: '11:21 PM',
        imageUrl: 'https://via.placeholder.com/150'),
    Message(
        sender: 'You',
        text: ' i am not sure',
        timestamp: '11:41 PM',
        imageUrl: 'https://via.placeholder.com/150'),
  ];

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mido'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return ChatBubble(
                  sender: message.sender,
                  text: message.text,
                  timestamp: message.timestamp,
                  isMe: message.sender == 'You',
                  imageUrl: message.imageUrl,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String text;
  final String timestamp;
  final bool isMe;
  final String imageUrl;

  const ChatBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isMe,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isMe)
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 12,
              ),
            if (!isMe) const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: isMe ? Colors.green[100] : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft:
                              isMe ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                              isMe ? Radius.zero : const Radius.circular(12),
                        )),
                    padding: const EdgeInsets.all(12),
                    child: Text(text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isMe) const SizedBox(width: 8),
            if (isMe)
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 12,
              ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final String timestamp;
  final String imageUrl;

  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.imageUrl,
  });
}
