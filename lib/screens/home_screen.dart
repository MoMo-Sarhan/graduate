import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';
import 'posts_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    PostPage(),
    const ChatPage(),
    const ScreenPage(color: Colors.blue, text: 'Screen 3'),
    const ScreenPage(color: Colors.orange, text: 'Screen 4'),
    const ScreenPage(color: Colors.orange, text: 'Screen 5'),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        items: <Widget>[
          Image.asset('assets/home.png', width: 30, height: 30),
          Image.asset('assets/communication.png', width: 30, height: 30),
          Image.asset('assets/chatbot.png', width: 30, height: 30),
          Image.asset('assets/setting.png', width: 30, height: 30),
          Image.asset('assets/online-course.png', width: 30, height: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
    );
  }
}

class ScreenPage extends StatelessWidget {
  final Color color;
  final String text;

  const ScreenPage({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
