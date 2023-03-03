import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/field_model.dart';
import '../../models/user_model.dart';
import '../addfield/add_field_screen.dart';
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

    // Curent user that is logged in
    final user = Provider.of<UserModel>(context);

    // StreamProvider listens to changes in Firestore collection 'fields'
    return StreamProvider<List<FieldModel>>.value(
      value: FieldsStore(userId: user.uid).fields,
      initialData: [],
      child: Scaffold(
          appBar: AppBar(
            title: Text('My fields'),
          ),
          backgroundColor: Colors.grey[200],
          body: Center(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/farm-background.jpg'),
                    fit: BoxFit.cover
                  )
                ),
                child: FieldList()
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'myfields_add',
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFieldScreen(),
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