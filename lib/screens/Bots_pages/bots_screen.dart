import 'package:flutter/material.dart';
import 'package:graduate/screens/Bots_pages/bot_chat_screen.dart';
import 'package:graduate/screens/Bots_pages/yuni_chat_screen.dart';

// ignore: camel_case_types
enum Bots { coher, yuni }

class BotsScreen extends StatelessWidget {
  static const id = 'chat bot screen';
  final List<String> bots = [
    'General chatbot',
    'Curriculum chatbot',
    'Summarization chatbot',
    'Improve writing chatbot',
    'Create quizzes chatbot',
    'Evaluate quizzes chatbot',
  ];

  final List<Bot> eliteTools = [
    Bot(
        name: 'General chatbot',
        description: 'Real-time chat with a bot',
        icon: 'assets/bot/chatbot.png',
        id: Bots.coher),
    Bot(
        name: 'Curriculum chatbot',
        description: 'Translate text to different languages',
        icon: 'assets/bot/bot (1).png',
        id: Bots.yuni),
    Bot(
        name: 'Summarization chatbot',
        description: 'Summarize text to the main points',
        icon: 'assets/bot/web.png',
        id: Bots.yuni),
    Bot(
        name: 'Improve writing chatbot',
        description: 'Check grammar and spelling mistakes',
        icon: 'assets/bot/ai-writing.png',
        id: Bots.yuni),
    Bot(
        name: 'Create quizzes chatbot',
        description: 'Create quizzes for your students',
        icon: 'assets/bot/robot.png',
        id: Bots.yuni),
    Bot(
        name: 'Evaluate quizzes chatbot',
        description: 'Evaluate quizzes for your students',
        icon: 'assets/bot/robot (1).png',
        id: Bots.yuni),
  ];

  final List<Map<String, String>> history = [
    {
      'title': 'Invalid input',
      'description': 'See your recent conversation',
      'icon': 'error'
    },
    // Add more history items here
  ];

  BotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
            child: const Text(
              'Chat & Ask',
              style: TextStyle(color: Colors.white),
            )),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elite Tools',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eliteTools.length,
                itemBuilder: (context, index) {
                  final tool = eliteTools[index];
                  return SizedBox(
                    width: 200,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                                milliseconds: 500), // Set the duration you want
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              if (tool.id == Bots.coher) {
                                return CoherScreen(
                                    icon: tool.icon,
                                    name: tool.name,
                                    description: tool.description);
                              }
                              return YuniScreen(
                                name: tool.name,
                                description: tool.description,
                                icon: tool.icon,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.purple[50],
                        margin: const EdgeInsets.only(right: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [Colors.white, Colors.purple],
                                  ).createShader(bounds);
                                },
                                child: Hero(
                                  tag: tool.icon,
                                  child: Image.asset(
                                    tool.icon,
                                    width: 64,
                                    height: 64,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tool.name,
                                style: const TextStyle(color: Colors.purple),
                              ),
                              Text(tool.description),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text(
                  'Recent Conversations',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.purple),
                  onPressed: () {
                    // Clear history
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Card(
                    color: Colors.purple[50],
                    child: ListTile(
                      title: Text(item['title']!),
                      subtitle: Text(item['description']!),
                      trailing:
                          const Icon(Icons.delete, color: Colors.deepPurple),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bot {
  String name;
  String description;
  String icon;
  Bots id;

  Bot(
      {required this.name,
      required this.description,
      required this.icon,
      required this.id});
}
