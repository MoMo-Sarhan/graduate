import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduate/Pages/BotPage.dart';
import 'package:graduate/Pages/CommunityPage.dart';
import 'package:graduate/Pages/CoursesPage.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/Pages/ProfilePage.dart';
import 'package:graduate/component/custom_naviagton_button.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/models/customNavigationbutton.dart';
import 'package:graduate/screens/bot_chat_screen.dart';
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
    List<MyBottomBarModel> buttonsBar = [];
    List<Widget> pages = [];

    return BlocBuilder<LoginStateCubit, SignUpState>(
      builder: (context, state) {
        if (state is SignUpAsGeneral) {
          double width = MediaQuery.of(context).size.width / 10;
          newButtonBar.addAll(<Widget>[
            Image.asset('assets/home.png', width: width, height: 30),
            Image.asset('assets/communication.png', width: width, height: 40),
            Image.asset(
              'assets/community.png',
              width: 30,
              height: 30,
            ),
            Image.asset('assets/chatbot.png', width: width, height: 30),
            // Image.asset('assets/online-course.png', width: 30, height: 30),
            Image.asset('assets/setting.png', width: width, height: 30),
          ]);
          // buttonsBar.addAll([
          //   MyBottomBarModel(
          //       icon: Icons.home, label: 'home', onpressed: () {}, index: 0),
          //   MyBottomBarModel(
          //       icon: Icons.people_alt,
          //       label: 'community',
          //       onpressed: () {},
          //       index: 1),
          //   MyBottomBarModel(
          //       icon: Icons.rocket, label: 'bot', onpressed: () {}, index: 2),
          //   MyBottomBarModel(
          //       icon: Icons.person,
          //       label: 'profile',
          //       onpressed: () {},
          //       index: 3)
          // ]);
          pages.addAll([
            HomePage(),
            ChatPage(),
            PostPage(),
            BotsScreen(),
            // BotPage(),
            // BotPage(),
            // ProfilePage(),
            SettingScreen()
          ]);
        } else {
          newButtonBar.addAll(<Widget>[
            Image.asset('assets/home.png', width: 30, height: 30),
            Image.asset('assets/communication.png', width: 30, height: 30),
            Image.asset(
              'assets/community.png',
              width: 30,
              height: 30,
            ),
            Image.asset('assets/chatbot.png', width: 30, height: 30),
            Image.asset('assets/online-course.png', width: 30, height: 30),
            Image.asset('assets/setting.png', width: 30, height: 30),
          ]);
          // buttonsBar.addAll([
          //   MyBottomBarModel(
          //       icon: Icons.home, label: 'home', onpressed: () {}, index: 0),
          //   MyBottomBarModel(
          //       icon: Icons.people_alt,
          //       label: 'community',
          //       onpressed: () {},
          //       index: 1),
          //   MyBottomBarModel(
          //       icon: Icons.rocket, label: 'bot', onpressed: () {}, index: 2),
          //   MyBottomBarModel(
          //       icon: Icons.book_sharp,
          //       label: 'Courses',
          //       onpressed: () {},
          //       index: 3),
          //   MyBottomBarModel(
          //       icon: Icons.person,
          //       label: 'profile',
          //       onpressed: () {},
          //       index: 4)
          // ]);
          pages.addAll([
            HomePage(),
            ChatPage(),
            PostPage(),
            BotsScreen(),
            // BotPage(),
            CoursesScreen(),
            // CoursesPage(),
            // ProfilePage(),
            SettingScreen()
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
                log(_selectedPage.toString());
                log(pages.length.toString());
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
            )
            // GNav(
            //     onTabChange: (value) {
            //       setState(() {
            //         _selectedPage = value.toInt();
            //         log(_selectedPage.toString());
            //       });
            //       _pageController.jumpToPage(_selectedPage);
            //     },
            //     textStyle: const TextStyle(fontSize: 3),
            //     activeColor: Colors.blue,
            //     selectedIndex: _selectedPage,
            //     tabs: buttonsBar
            //         .map((e) =>
            //             bottomNavigationBarItem(bar: e, selected: _selectedPage))
            //         .toList()),
            );
      },
    );
  }
}
