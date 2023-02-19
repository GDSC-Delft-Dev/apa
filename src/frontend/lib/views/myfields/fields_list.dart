import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:provider/provider.dart';

class FieldList extends StatefulWidget {

  const FieldList({super.key});

  @override
  _FieldListState createState() => _FieldListState();

}

class _FieldListState extends State<FieldList> {
  @override
  Widget build(BuildContext context) {

    final fields = Provider.of<List<FieldModel>>(context);
    fields.forEach((field) {
      print(field.fieldName);
      print(field.area);
    });

    return Scaffold(
      body: Text(fields.toString()),
    );
  }

}