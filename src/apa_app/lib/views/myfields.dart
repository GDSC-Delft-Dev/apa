import 'package:flutter/material.dart';

class MyFields extends StatefulWidget {

  const MyFields({super.key});

  @override
  _MyFieldsState createState() => _MyFieldsState();

}

class _MyFieldsState extends State<MyFields> {

  int _numFields = 0;

  void _incrementFields() {
    setState(() {
      _numFields++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My fields'),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Text('Listview of my $_numFields fields', style: TextStyle(fontSize: 50),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementFields,
        tooltip: 'Add field',
        child: const Icon(Icons.add, size: 35, color: Colors.white,),
      ),
    );
  }

}