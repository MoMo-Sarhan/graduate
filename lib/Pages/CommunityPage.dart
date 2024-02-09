import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graduate/Pages/HomePage.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final StreamController _controller = StreamController<int>();
  List<int> dataList = [];
  @override
  Widget build(BuildContext context) {

    ScrollController _pageController = ScrollController();
    return Scaffold(
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dataList.add(snapshot.data);
            return ListView.builder(
                controller: _pageController,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Text(dataList[index].toString()),
                  );
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Text('Wating ....'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _controller.add(DateTime.now().second);

          _pageController.animateTo(_pageController.position.maxScrollExtent,
              duration: Duration(seconds: 1), curve: Curves.bounceIn);
        },
      ),
    );
  }
}
