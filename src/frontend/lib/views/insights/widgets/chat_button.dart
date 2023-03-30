import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:frontend/views/insights/widgets/hidden_drawer.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Opens the chat screen.
          Navigator.pushNamed(context, '/chat');
        },
        child: const Icon(Icons.chat_bubble));
  }
}
