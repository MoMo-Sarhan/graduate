import 'package:flutter/material.dart';

class CustomMessageFiled extends StatelessWidget {
  const CustomMessageFiled(
      {super.key,
      required this.messageController,
      required this.onPressed,
      required this.onChange});
  final TextEditingController messageController;
  final Function() onPressed;
  final Function(dynamic) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          onChanged: onChange,
          controller: messageController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Type a message',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: onPressed,
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // Implement camera button functionality
              },
            ),
          ),
          minLines: 1,
          maxLines: 7, // Allow TextField to grow vertically
        ),
      ),
    );
  }
}
