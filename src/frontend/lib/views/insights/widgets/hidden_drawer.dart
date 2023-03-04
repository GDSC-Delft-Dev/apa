import 'package:flutter/material.dart';
import 'menu_item.dart';


class InsightMenuItems {

  static List<InsightMenuItem> choices = [
    const InsightMenuItem('Pests', Icons.bug_report),
    const InsightMenuItem('Diseases', Icons.sick),
    const InsightMenuItem('Nutrient Deficiencies', Icons.water_drop),
  ];

}


class HiddenDrawer extends StatefulWidget {
  
  const HiddenDrawer({super.key});


  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();

}

class _HiddenDrawerState extends State<HiddenDrawer> {

  // TODO: share these choices with the insights map widget
  final List<InsightMenuItem> _selectedInsights = [...InsightMenuItems.choices];  // All choices are selected by default

  void _itemChange(InsightMenuItem item, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedInsights.add(item);
      } else {
        _selectedInsights.remove(item);
      }
    });
    print('Selected: ${_selectedInsights.length} items and choices has ${InsightMenuItems.choices.length}');
  }

  Widget buildMenuItems(InsightMenuItem item) => CheckboxListTile(
    activeColor: Colors.orange,
    dense: true,
    secondary: Icon(item.icon, color: Colors.white),
    title: Text(
      item.title,
      style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 0.5),
    ),
    value: _selectedInsights.contains(item),
    onChanged: (bool? isChecked) => _itemChange(item, isChecked!)
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
