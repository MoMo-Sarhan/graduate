import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class AnimationHomePage extends StatefulWidget {
  AnimationHomePage({required this.direction, required this.second});
  final int second;
  final Axis direction;
  @override
  _AnimationHomePageState createState() => _AnimationHomePageState();
}

class _AnimationHomePageState extends State<AnimationHomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 3; // Change this to the total number of pages
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(Duration(seconds: widget.second), (timer) {
      // Change page every 5 seconds
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: PageView(
          scrollDirection: widget.direction,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            // Your page 1 widget
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.amber),
              child: Center(
                child: Text('Page 1'),
              ),
            ),
            // Your page 2 widget
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.blue),
              child: Center(
                child: Text('Page 2'),
              ),
            ),
            // Your page 3 widget
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.red),
              child: Center(
                child: Text('Page 3'),
              ),
            ),
            // Add more pages as needed
          ],
        ),
      ),
    );
  }
}
