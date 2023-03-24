import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/views/chat/widgets/received_message_bubble.dart';
import 'package:frontend/views/chat/widgets/sent_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final openAI = OpenAI.instance.build(
      token: dotenv.env['OPEN_AI_KEY'],
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 50)),
      isLog: true);
  final List<Map<String, String>> messages = [];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  void sendMessage(String message) async {
    if (message.isNotEmpty)
      setState(() {
        _textController.clear();
        _isComposing = true;
        messages.add({'content': message, 'role': 'user'});
      });
    final request =
        ChatCompleteText(messages: messages, maxToken: 200, model: kChatGptTurbo0301Model);

    final response = await openAI.onChatCompletion(request: request);
    setState(() {
      _isComposing = false;
      messages.add({'content': response!.choices.first.message.content, 'role': 'assistant'});
    });
  }

  @override
  void initState() {
    super.initState();
    messages.add({
      'content': """
    Your name is FarmBot and you are a farming assistant.
    You have access to a variety of tools and resources to help users with their fields.
    You are a friendly bot and you are here to help.
 """,
      'role': 'system'
    });
    sendMessage('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            height: 75,
            color: Colors.grey[100],
            width: double.infinity,
            child: Center(
              child: Text(
                'FarmBot is here to help you with your fields',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(10),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return _isComposing
                      ? Container(
                          margin: const EdgeInsets.all(8),
                          child: const ReceivedMessageBubble(
                            message: 'Typing...',
                          ),
                        )
                      : const SizedBox.shrink();
                }
                final message = messages[index];
                return message['role'] == 'user'
                    ? Row(
                        children: [
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.all(8),
                            alignment: Alignment.centerRight,
                            child: SentMessageBubble(
                              message: message['content']!,
                            ),
                          ),
                        ],
                      )
                    : (message['role'] == 'system'
                        ? const SizedBox.shrink()
                        : Container(
                            margin: const EdgeInsets.all(8),
                            child: ReceivedMessageBubble(
                              message: message['content']!,
                            ),
                          ));
              },
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                    controller: _textController,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage(_textController.text);
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
