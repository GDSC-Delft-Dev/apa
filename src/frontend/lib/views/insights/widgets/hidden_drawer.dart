import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'menu_item.dart';


class InsightMenuItems {

  static List<InsightMenuItem> choices = [
    InsightMenuItem('Pests', Icons.bug_report, true),
    InsightMenuItem('Diseases', Icons.sick, true),
    InsightMenuItem('Nutrient Deficiencies', Icons.water_drop, true),
  ];

}


class HiddenDrawer extends StatefulWidget {
  
  const HiddenDrawer({super.key});


  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();

}

class _HiddenDrawerState extends State<HiddenDrawer> {

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

  // TODO: Change into CheckboxListTile
  Widget buildMenuItems(InsightMenuItem item) => CheckboxListTile(
    activeColor: Colors.orange,
    dense: true,
    secondary: Icon(item.icon, color: Colors.white),
    title: Text(
      item.title,
      style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 0.5),
    ),
    value: item.isChecked,
    onChanged: (bool? value) {
      setState(() {
        item.isChecked = value!;
      });
    },
  );
  }
