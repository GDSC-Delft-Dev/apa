import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/views/insights/field_insights.dart';

import '../insights/insights_wrapper.dart';
import 'widgets/canvas_field.dart';

class FieldTile extends StatelessWidget {
  final FieldModel field;

  FieldTile({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              leading: CanvasField(field: field),
              title: Text(field.fieldName),
              subtitle: Text('${field.area} ha'),
              trailing: field.hasInsights
                  ? const Icon(Icons.keyboard_arrow_right_sharp,)
                  : const Text(
                      'No insights yet',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
              onTap: field.hasInsights
                  ? () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InsightsWrapper(fieldId: field.fieldId),
                          ));
                    }
                  : null,
            )));
  }
}

