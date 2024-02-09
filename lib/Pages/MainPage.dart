import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduate/Pages/BotPage.dart';
import 'package:graduate/Pages/CommunityPage.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/Pages/ProfilePage.dart';
import 'package:graduate/component/custom_naviagton_button.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/customNavigationbutton.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;
  List<MyBottomBarModel> buttonsBar = [
    MyBottomBarModel(
        icon: Icons.home, label: 'home', onpressed: () {}, index: 0),
    MyBottomBarModel(
        icon: Icons.people_alt, label: 'community', onpressed: () {}, index: 1),
    MyBottomBarModel(
        icon: Icons.chat, label: 'chat', onpressed: () {}, index: 2),
    MyBottomBarModel(
        icon: Icons.person, label: 'profile', onpressed: () {}, index: 3)
  ];
  List<Widget> pages = [HomePage(), CommunityPage(), BotPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (value) {
            setState(() => _selectedPage = value);
            log(_selectedPage.toString());
          },
          itemBuilder: (context, index) => pages[index]),
      bottomNavigationBar: GNav(
          onTabChange: (value) {
            setState(() {
              _selectedPage = value.toInt();
              log(_selectedPage.toString());
            });
            _pageController.jumpToPage(_selectedPage);
          },
          activeColor: Colors.blue,
          selectedIndex: _selectedPage,
          gap: 8,
          tabs: buttonsBar
              .map((e) =>
                  bottomNavigationBarItem(bar: e, selected: _selectedPage))
              .toList()),
    );
  }
}
