import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/visualize_insights_map.dart';
import 'package:provider/provider.dart';

import '../../models/field_model.dart';
import '../../models/user_model.dart';
import '../../stores/fields_store.dart';

/// Displays insights for this field and allows user to customize visualization mode
class FieldInsights extends StatefulWidget {

  final String fieldId;

  const FieldInsights({ required this.fieldId });

  @override
  State<FieldInsights> createState() => _FieldInsightsState();
}

// TODO: use StreamBuilder to fetch data corresponding to this field

class _FieldInsightsState extends State<FieldInsights> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    return StreamProvider<List<FieldModel>>.value(
      value: FieldsStore(userId: user.uid).fields,
      initialData: [],
      child: Scaffold(
          appBar: AppBar(
            title: Text('Field insights'),
          ),
          backgroundColor: Colors.grey[200],
          body: Center(
            child: VisualizeInsightsMap(currFieldId: widget.fieldId),
            // child: Text('Field maps and localized insights for field with id ${widget.fieldId}', style: TextStyle(fontSize: 20),),
          )
      ),
    );
  }
}
