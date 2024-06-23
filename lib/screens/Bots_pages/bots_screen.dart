import 'package:flutter/material.dart';
import 'package:graduate/screens/Bots_pages/bot_chat_screen.dart';
import 'package:graduate/screens/Bots_pages/greate_bot_chat_screen.dart';
import 'package:graduate/services/bot/greate_bot_model.dart';

// ignore: camel_case_types
enum Bots { yuni, yuno, yoda, imporvewriting, evaluatequiz, createquiz }

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
        botName: Bots.yuni.name,
        url: 'https://pikachu65-yuni.hf.space',
        name: 'General chatbot',
        description: 'General purpose language model',
        icon: 'assets/bot/bot (1).png',
        id: Bots.yuni),
    Bot(
        botName: Bots.yuno.name,
        url: 'https://pikachu65-yuno.hf.space',
        name: 'Curriculum chatbot',
        description:
            'A specialized model that answers question exclusively lectures',
        icon: 'assets/bot/web.png',
        id: Bots.yuno),
    Bot(
        botName: Bots.yoda.name,
        url: 'https://pikachu65-yoda.hf.space',
        name: 'Summarizer Model',
        description: 'A comprehensive summarizer',
        icon: 'assets/bot/ai-writing.png',
        id: Bots.yoda),
    Bot(
        botName: Bots.imporvewriting.name,
        url: 'https://pikachu65-improvewriting.hf.space',
        name: 'Create Improve Writing',
        description: 'Enhances student writing by refining text ...',
        icon: 'assets/bot/robot.png',
        id: Bots.imporvewriting),
    Bot(
        botName: Bots.evaluatequiz.name,
        url: 'https://pikachu65-evaluatequiz.hf.space',
        name: 'Evaluate quizzes chatbot',
        description: 'Evaluate quizzes for your students',
        icon: 'assets/bot/robot (1).png',
        id: Bots.evaluatequiz),
    Bot(
      botName: Bots.createquiz.name,
      url: 'https://pikachu65-createquiz.hf.space',
      name: 'Create Quiz',
      description: 'Exclusively designed for professors',
      icon: 'assets/bot/chatbot.png',
      id: Bots.createquiz,
    ),
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
                              return GreateBotScreenChat(
                                name: tool.name,
                                description: tool.description,
                                icon: tool.icon,
                                botClient: GreateBot(
                                    baseUrl: tool.url, botName: tool.botName),
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
                      subtitle: Text(
                        item['description']!,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
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
  String botName;
  String url;
  String icon;
  Bots id;

  Bot(
      {required this.botName,
      required this.url,
      required this.name,
      required this.description,
      required this.icon,
      required this.id});
}
