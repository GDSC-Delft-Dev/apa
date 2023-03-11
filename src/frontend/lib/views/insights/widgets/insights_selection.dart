import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/models/insight_type_model.dart';
import 'package:frontend/providers/insight_choices_provider.dart';
import 'package:frontend/providers/insight_types_provider.dart';
import 'package:provider/provider.dart';

/// A widget that displays a hidden drawer that can be opened by swiping from the left edge of the screen
class InsightsSelection extends StatefulWidget {
  const InsightsSelection({super.key});

  @override
  _InsightsSelectionState createState() => _InsightsSelectionState();
}

class _InsightsSelectionState extends State<InsightsSelection> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildMenuItem(InsightTypeModel item) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => CheckboxListTile(
            activeColor: Colors.green,
            dense: true,
            secondary: CachedNetworkImage(
              imageUrl: item.icon,
              height: 20,
              width: 40,
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontSize: 13, letterSpacing: 0.5),
            ),
            value: Provider.of<InsightChoicesProvider>(context).isInsightTypeSelected(item.id),
            onChanged: (bool? isChecked) => {
              setState(() {
                Provider.of<InsightChoicesProvider>(context, listen: false)
                    .setInsightTypeSelection(item.id, isChecked!);
              })
            },
          ));

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Pick localized insights to display'),
                content: SingleChildScrollView(
                    child: ListBody(
                        children: Provider.of<InsightTypesProvider>(context)
                            .insightTypes
                            .map(buildMenuItem)
                            .toList())),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Done'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.lightbulb_outline));
  }
}
