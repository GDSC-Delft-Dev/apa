import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddField extends StatefulWidget {

  const AddField({super.key});

  @override
  _AddFieldState createState() => _AddFieldState();
}

class _AddFieldState extends State<AddField> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
          Center(
            child: ElevatedButton(
                  child: Text('Add dummy field'),
                  onPressed: () => {print('Add new field to fields collection')}
              )
          ),
      ),
    );
  }

}