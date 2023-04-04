import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class SentMessageBubble extends StatelessWidget {
  final String message;

  const SentMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
      backGroundColor: const Color(0xffE7E7ED),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
