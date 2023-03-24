import 'package:flutter/material.dart';

/// A simple widget that displays a card with a text and a textfield for 
/// adding field details.
class AddFieldInfoCard extends StatelessWidget {
  const AddFieldInfoCard(
      {super.key, required this.textController, required this.hintText, required this.text, required this.onChange});

  final TextEditingController textController;
  final String hintText;
  final String text;
  final Function() onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade800,
                  letterSpacing: 0.05,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: textController,
                onChanged: (value) => onChange(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.05,
                ),
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