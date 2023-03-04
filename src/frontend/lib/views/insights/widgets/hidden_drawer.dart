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


class HiddenDrawer extends StatefulWidget {
  
  const HiddenDrawer({super.key});


  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();

}

class _HiddenDrawerState extends State<HiddenDrawer> { 
  
  @override
  void initState() {
    super.initState();
  }

    Widget buildMenuItems(InsightMenuItem item) => CheckboxListTile(
    activeColor: Colors.orange,
    dense: true,
    secondary: Icon(item.icon, color: Colors.white),
    title: Text(
      item.title,
      style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 0.5),
    ),
    value: Provider.of<InsightChoicesProvider>(context).selectedInsights.contains(item.type),
    onChanged: (bool? isChecked) => Provider.of<InsightChoicesProvider>(context, listen: false).itemChange(item, isChecked!),
    );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Text(
                'Pick localized insights to display on map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...InsightMenuItems.choices.map(buildMenuItems).toList(),
            const Spacer(flex: 2),
          ],)
      ),
    );
  }

  }
