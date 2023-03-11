import 'package:flutter/material.dart';
import 'package:frontend/models/insight_model.dart';
import 'package:frontend/providers/insight_choices_provider.dart';
import 'menu_item.dart';
import 'package:provider/provider.dart';

class InsightMenuItems {

  static List<InsightMenuItem> choices = [
    const InsightMenuItem('Pests', Icons.bug_report, InsightType.pest),
    const InsightMenuItem('Diseases', Icons.sick, InsightType.disease),
    const InsightMenuItem('Nutrient Deficiencies', Icons.water_drop, InsightType.nutrient),
  ];

}


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

    Widget buildMenuItems(InsightMenuItem item) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) => CheckboxListTile(
      activeColor: Colors.green,
      dense: true,
      secondary: Icon(item.icon, color: Colors.black),
      title: Text(
        item.title,
        style: TextStyle(fontSize: 13, letterSpacing: 0.5),
      ),
      value: Provider.of<InsightChoicesProvider>(context).selectedInsights.contains(item.type),
      onChanged: (bool? isChecked) => {
          setState(() {
            Provider.of<InsightChoicesProvider>(context, listen: false).itemChange(item, isChecked!);
          })
      } ,
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
                            children: InsightMenuItems.choices.map(buildMenuItems).toList()
                          )
                          ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              child: Icon(
                  Icons.lightbulb_outline)
    );
  }

  }
