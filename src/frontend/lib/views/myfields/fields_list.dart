import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:provider/provider.dart';

/// This widget is used within the "My Fields" screen to list
class FieldList extends StatefulWidget {

  const FieldList({super.key});

  @override
  _FieldListState createState() => _FieldListState();

}

class _FieldListState extends State<FieldList> {
  @override
  Widget build(BuildContext context) {

    final fields = Provider.of<List<FieldModel>>(context);

    return Scaffold(
      body: Column(
        children: [
          // TODO: create tiles for all fields to display (see issue #16)
          for (var field in fields) Center(child: Text(field.fieldName))
        ],
      ),
    );
  }

}