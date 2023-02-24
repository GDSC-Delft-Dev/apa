import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/views/insights/field_insights.dart';

class FieldTile extends StatelessWidget {

  final FieldModel field;

  FieldTile ({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            leading: Icon(Icons.map_outlined),
            // TODO: display crop
            // TODO: add crop type icon or map of field
            title: Text(field.fieldName),
            subtitle: Text('${field.area} ha'),
            trailing: Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FieldInsights(),
                  )
              );
            },
          )
        )
    );
  }
}
