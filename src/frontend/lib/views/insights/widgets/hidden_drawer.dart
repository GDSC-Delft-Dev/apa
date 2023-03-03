import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../widgets/menu_item.dart';


class MenuItems {
 
  static const pests = MenuItem('Pests', Icons.bug_report);
  static const diseases = MenuItem('Diseases', Icons.sick);
  static const nutrientDeficiencies = MenuItem('Nutrient Deficiencies', Icons.water_drop);

  static const items = <MenuItem>[
    pests,
    diseases,
    nutrientDeficiencies,
  ];

}


class HiddenDrawer extends StatelessWidget {
  
  const HiddenDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            ...MenuItems.items.map(buildMenuItems).toList(),
            Spacer(flex: 2),
          ],)
      ),
    );
  }

  // // TODO: Change into CheckboxListTile
  // Widget buildMenuItems(MenuItem item) => CheckboxListTile(
  //   activeColor: Colors.green,
  //   dense: true,
  //   title: Text(
  //     item.title,
  //     style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 0.5),
  //   ),
  //   value: ,
  //   onChanged: null,
  // );

    // TODO: Change into CheckboxListTile
  Widget buildMenuItems(MenuItem item) => ListTile(
    minLeadingWidth: 20,
    leading: Icon(item.icon, color: Colors.white),
    title: Text(
      item.title,
      style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 0.5),
    ),
    onTap: () {},
  );

}