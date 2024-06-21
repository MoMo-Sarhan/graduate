import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/screens/bots_screen.dart';
import 'package:graduate/screens/chat_page.dart';
import 'package:graduate/screens/courses_screen.dart';
import 'package:graduate/screens/posts_page.dart';
import 'package:graduate/screens/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> newButtonBar = [];
    List<Widget> pages = [];

    return BlocBuilder<LoginStateCubit, SignUpState>(
      builder: (context, state) {
        if (state is SignUpAsGeneral) {
          double width = MediaQuery.of(context).size.width / 10;
          newButtonBar.addAll(<Widget>[
            Image.asset('assets/home.png', width: width, height: 30),
            Image.asset('assets/communication.png', width: width, height: 40),
            ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                child: Image.asset(
                  'assets/community.png',
                  width: 30,
                  height: 30,
                  color: Colors.white,
                )),
            Image.asset('assets/chatbot.png', width: width, height: 30),
            // Image.asset('assets/online-course.png', width: 30, height: 30),
            Image.asset('assets/setting.png', width: width, height: 30),
          ]);
          pages.addAll([
            const HomePage(),
            const ChatPage(),
            PostPage(),
            BotsScreen(),
            const SettingScreen()
          ]);
        } else {
          newButtonBar.addAll(<Widget>[
            Image.asset('assets/home.png', width: 30, height: 30),
            Image.asset('assets/communication.png', width: 30, height: 30),
            ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                child: Image.asset(
                  'assets/community.png',
                  width: 30,
                  height: 30,
                  color: Colors.white,
                )),
            Image.asset('assets/chatbot.png', width: 30, height: 30),
            Image.asset('assets/online-course.png', width: 30, height: 30),
            Image.asset('assets/setting.png', width: 30, height: 30),
          ]);
          pages.addAll([
            const HomePage(),
            const ChatPage(),
            PostPage(),
            BotsScreen(),
            const CoursesScreen(),
            const SettingScreen()
          ]);
        }
        log(state.toString());

        return Scaffold(
            body: PageView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: pages.length,
              itemBuilder: (context, index) => pages[index],
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _selectedPage = value;
                });
              },
            ),
            bottomNavigationBar: CurvedNavigationBar(
              index: _selectedPage,
              items: newButtonBar,
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: const Color(0xffB9B4F6),
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 600),
              onTap: (value) {
                setState(() {
                  _selectedPage = value.toInt();
                  log(_selectedPage.toString());
                });
                _pageController.jumpToPage(_selectedPage);
              },
            ));
      },
    );
  }
}
