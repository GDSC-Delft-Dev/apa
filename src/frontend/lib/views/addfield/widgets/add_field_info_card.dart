import 'package:flutter/material.dart';

/// A simple widget that displays a card with a text and a textfield for 
/// adding field details.
class AddFieldInfoCard extends StatelessWidget {
  const AddFieldInfoCard(
      {super.key, required this.textController, required this.hintText, required this.text});

  final TextEditingController textController;
  final String hintText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade700,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.05,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: hintText,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}