// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/setting_pages/Change_icon_page.dart';
import 'package:graduate/Pages/setting_pages/Rating_Page.dart';
import 'package:graduate/Pages/setting_pages/change_name_page.dart';
import 'package:graduate/component/settingItem.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/models/settingModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void change_name() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChangeNamePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listItem = [
      CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: Image(image: AssetImage('assets/icons/college.png')),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'General Settings',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Item(
          settingItem: SettingModel(
              text: 'Change Icon',
              icon_1: Icons.person,
              icon_2: Icons.arrow_forward_ios,
              onpressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeIconPage();
                }));
              })),
      Item(
          settingItem: SettingModel(
              text: 'Change Name',
              icon_1: Icons.person,
              icon_2: Icons.arrow_forward_ios,
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangeNamePage()));
              })),
      Item(
          settingItem: SettingModel(
              text: 'Apperance',
              icon_1: BlocProvider.of<ModeStateCubit>(context).mode
                  ? Icons.dark_mode
                  : Icons.light_mode,
              icon_2: BlocProvider.of<ModeStateCubit>(context).mode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              onpressed: () {
                setState(() {});
                BlocProvider.of<ModeStateCubit>(context).mode =
                    !BlocProvider.of<ModeStateCubit>(context).mode;
                log(BlocProvider.of<ModeStateCubit>(context).mode.toString());
              })),
      Item(
          settingItem: SettingModel(
              text: 'Get Notifications',
              icon_1: Icons.notifications,
              icon_2: Icons.toggle_off_outlined,
              onpressed: () {})),
      Item(
          settingItem: SettingModel(
              text: 'Rate The App',
              icon_1: Icons.star,
              icon_2: Icons.arrow_forward_ios,
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RatingPage()));
              })),
      Item(
          settingItem: SettingModel(
              text: 'Privcy and Terms',
              icon_1: Icons.person,
              icon_2: Icons.arrow_forward_ios,
              onpressed: () {})),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: Center(child: Text('LogOut')),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel')),
                          SizedBox(
                            width: 100,
                          ),
                          TextButton(
                              onPressed: () async {
                                BlocProvider.of<ModeStateCubit>(context).mode =
                                    false;
                                await BlocProvider.of<LoginStateCubit>(context)
                                    .SignOut();
                                Navigator.of(context).pop();
                              },
                              child: Text('log out')),
                        ],
                      )));
            },
            icon: Icon(Icons.logout),
            iconSize: 30,
          )
        ],
      ),
      body: ListView.builder(
          itemCount: listItem.length,
          itemBuilder: (context, index) {
            return listItem[index];
          }),
    );
  }
}
