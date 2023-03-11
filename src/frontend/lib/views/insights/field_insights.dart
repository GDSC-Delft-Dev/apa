import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/bottom_time_sheet.dart';
import 'package:frontend/views/insights/widgets/visualize_insights_map.dart';
import 'package:frontend/views/loading.dart';
import 'package:provider/provider.dart';
import '../../models/field_model.dart';
import '../../models/insight_model.dart';
import '../../models/user_model.dart';
import '../../stores/fields_store.dart';
import '../../stores/insights_type_store.dart';

/// Displays insights for this field and allows user to customize visualization mode
class FieldInsights extends StatefulWidget {
  final String fieldId;

  const FieldInsights({super.key, required this.fieldId});

  @override
  State<FieldInsights> createState() => _FieldInsightsState();
}

class _FieldInsightsState extends State<FieldInsights> {
  Future<FieldModel> _getFieldModel() async {
    final user = Provider.of<UserModel>(context);
    final FieldModel currField = await FieldsStore(userId: user.uid).getFieldById(widget.fieldId);
    return currField;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FieldModel>(
      future: _getFieldModel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final FieldModel currField = snapshot.data!; // Assert that snapshot.data is not null
          return StreamProvider<List<InsightModel>>.value(
              value: InsightsStore().insights,
              initialData: [],
              child: Scaffold(
                appBar: AppBar(title: Text('Field insights: ${currField.fieldName}')),
                backgroundColor: Colors.grey[200],
                body: Stack(
                  children: [
                    Center(
                      child: VisualizeInsightsMap(currField: currField),
                    ),
                    BottomTimeSheet(
                      fieldModel: currField,
                    )
                  ],
                ),
              ));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Loading();
      },
    );
  }
}
