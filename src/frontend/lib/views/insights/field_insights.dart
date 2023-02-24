import 'package:flutter/material.dart';

class FieldInsights extends StatefulWidget {

  final String fieldId;

  const FieldInsights({ required this.fieldId });

  @override
  State<FieldInsights> createState() => _FieldInsightsState();
}

class _FieldInsightsState extends State<FieldInsights> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Field insights'),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text('Field maps and localized insights for field with id ${widget.fieldId}', style: TextStyle(fontSize: 20),),
        )
    );
  }
}
