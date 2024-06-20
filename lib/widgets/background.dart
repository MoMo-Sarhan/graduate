import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xffB2CEF0), // Light blue
            const Color(0xFFFFFFFF).withOpacity(0.5), // White (subtle touch)
            const Color(0xffB6B1F6), // Light purple
            const Color(0xFFFFFFFF), // White
          ],
          stops: const [0.2, 0.7, 0.6, 1.0],
        ),
      ),
    );
  }
}
