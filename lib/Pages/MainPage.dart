import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    List<MyBottomBarModel> buttonsBar = [];
    List<Widget> pages = [];
    // [
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
    //       icon: Icons.book_sharp, label: 'Courses', onpressed: () {}, index: 3),
    //   MyBottomBarModel(
    //       icon: Icons.person, label: 'profile', onpressed: () {}, index: 4)
    // ];
    return BlocBuilder<LoginStateCubit, SignUpState>(
      builder: (context, state) {
        if (state is SignUpAsGeneral) {
          buttonsBar.addAll([
            MyBottomBarModel(
                icon: Icons.home, label: 'home', onpressed: () {}, index: 0),
            MyBottomBarModel(
                icon: Icons.people_alt,
                label: 'community',
                onpressed: () {},
                index: 1),
            MyBottomBarModel(
                icon: Icons.rocket, label: 'bot', onpressed: () {}, index: 2),
            MyBottomBarModel(
                icon: Icons.person,
                label: 'profile',
                onpressed: () {},
                index: 3)
          ]);
          pages.addAll(const [
            HomePage(),
            CommunityPage(),
            BotPage(),
            ProfilePage(),
          ]);
        } else {
          buttonsBar.addAll([
            MyBottomBarModel(
                icon: Icons.home, label: 'home', onpressed: () {}, index: 0),
            MyBottomBarModel(
                icon: Icons.people_alt,
                label: 'community',
                onpressed: () {},
                index: 1),
            MyBottomBarModel(
                icon: Icons.rocket, label: 'bot', onpressed: () {}, index: 2),
            MyBottomBarModel(
                icon: Icons.book_sharp,
                label: 'Courses',
                onpressed: () {},
                index: 3),
            MyBottomBarModel(
                icon: Icons.person,
                label: 'profile',
                onpressed: () {},
                index: 4)
          ]);
          pages.addAll(const [
            HomePage(),
            CommunityPage(),
            BotPage(),
            CoursesPage(),
            ProfilePage(),
          ]);
        }
        log(state.toString());

        return Scaffold(
          body: PageView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) => pages[index],
            controller: _pageController,
            onPageChanged: (value) {
              setState(() => _selectedPage = value);
              log(_selectedPage.toString());
            },
          ),
          bottomNavigationBar: GNav(
              onTabChange: (value) {
                setState(() {
                  _selectedPage = value.toInt();
                  log(_selectedPage.toString());
                });
                _pageController.jumpToPage(_selectedPage);
              },
              textStyle: TextStyle(fontSize: 3),
              activeColor: Colors.blue,
              selectedIndex: _selectedPage,
              tabs: buttonsBar
                  .map((e) =>
                      bottomNavigationBarItem(bar: e, selected: _selectedPage))
                  .toList()),
        );
      },
    );
  }
}
