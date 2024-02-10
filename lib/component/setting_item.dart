// ignore_for_file: prefer_const_constructors
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduate/Pages/setting_pages/Change_icon_page.dart';
import 'package:graduate/Pages/setting_pages/Language_page.dart';
import 'package:graduate/Pages/setting_pages/Rating_Page.dart';
import 'package:graduate/Pages/setting_pages/change_name_page.dart';
import 'package:graduate/models/settingModel.dart';

class Item extends StatefulWidget {
  const Item({super.key, required this.settingItem});
  final SettingModel settingItem;
  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool notificationFlag=false;
  void onPressed() {
    setState(() {
      if (widget.settingItem.text == 'Change Name') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChangeNamePage()));
      }

      if (widget.settingItem.text == 'Apperance') {
        var temp = widget.settingItem.icon_1;
        widget.settingItem.icon_1 = widget.settingItem.icon_2;
        widget.settingItem.icon_2 = temp;
      }
      if (widget.settingItem.text == 'Language') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LanguagePage()));
      }
      if (widget.settingItem.text == 'Get Notifications') {
        notificationFlag = !notificationFlag;
        log(notificationFlag.toString());
        widget.settingItem.icon_1 =
            notificationFlag ? Icons.notifications_active : Icons.notifications;
        widget.settingItem.icon_2 = notificationFlag
            ? Icons.toggle_on_rounded
            : Icons.toggle_off_outlined;
      }
      if (widget.settingItem.text == 'Rate The App') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RatingPage()));
      }
      if (widget.settingItem.text == 'Change Icon') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChangeIconPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(children: [
            Spacer(
              flex: 1,
            ),
            Icon(
              widget.settingItem.icon_1,
            ),
            Spacer(
              flex: 1,
            ),
            SizedBox(
              width: 100,
              child: Text(
                widget.settingItem.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                widget.settingItem.icon_2,
              ),
            ),
          ]),
        ),
        Divider(
          color: Colors.amber,
          indent: 75,
          endIndent: 75,
        )
      ],
    );
  }
}
