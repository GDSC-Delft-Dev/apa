import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/field_model.dart';
import '../addfield/addfield.dart';
import 'fields_list.dart';

/// This screen allows users to inspect and manage all of their fields
class MyFields extends StatefulWidget {

  const MyFields({super.key});

  @override
  _MyFieldsState createState() => _MyFieldsState();

}

class _MyFieldsState extends State<MyFields> {

  @override
  Widget build(BuildContext context) {

    // StreamProvider listens to changes in Firestore collection 'fields'
    return StreamProvider<List<FieldModel>>.value(
      // TODO: get current user uid
      value: FieldsStore(uid: 'NlDfTwwMaYaVB1eTYYIkAdSDkMg1').fields,
      initialData: [],
      child: Scaffold(
          appBar: AppBar(
            title: Text('My fields'),
          ),
          backgroundColor: Colors.grey[200],
          body: Center(
            child: FieldList(),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'myfields_add',
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
        ),
    );
  }

}