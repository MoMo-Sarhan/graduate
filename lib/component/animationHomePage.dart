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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/images/1.png'), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(8),
                color: Colors.amber,
              ),
            ),
            // Your page 2 widget
            Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/images/2.png'),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue),
            ),
            // Your page 3 widget
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/images/3.png'),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red),
            ),
            // Add more pages as needed
          ],
        ),
      ),
    );
  }
}
