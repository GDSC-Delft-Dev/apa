import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../addfield/addfield.dart';

class MyFields extends StatefulWidget {

  const MyFields({super.key});

  @override
  _MyFieldsState createState() => _MyFieldsState();

}

class _MyFieldsState extends State<MyFields> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My fields'),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text('Listview of my fields', style: TextStyle(fontSize: 50),),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddField(),
                )
            );
          },
          tooltip: 'Add field',
          child: const Icon(Icons.add, size: 35, color: Colors.white,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
  }

}