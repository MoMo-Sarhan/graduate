// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:graduate/models/settingModel.dart';

class Item extends StatefulWidget {
  const Item({required this.settingItem});
  final SettingModel settingItem;
  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool notificationFlag = false;

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
              onPressed: widget.settingItem.onpressed,
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
