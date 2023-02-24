import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:provider/provider.dart';

import 'field_tile.dart';

/// This widget is used within the "My Fields" screen to list
class FieldList extends StatefulWidget {

  const FieldList({super.key});

  @override
  _FieldListState createState() => _FieldListState();

}

class _FieldListState extends State<FieldList> {
  @override
  Widget build(BuildContext context) {

    // Gets StreamProvider instances (from parent widget my_fields.dart) - Firebase documents of fields
    // TODO: we only wanna display fields of this user
    final fields = Provider.of<List<FieldModel>>(context);

    return ListView.builder(
        itemCount: fields.length,
        itemBuilder: (context, index) {
          return FieldTile(field: fields[index]);
        },
    );
  }

}