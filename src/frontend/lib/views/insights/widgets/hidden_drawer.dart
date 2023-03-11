import 'package:flutter/material.dart';
import 'package:frontend/views/insights/field_insights.dart';
import '../../loading.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';


/// A widget that displays a hidden drawer that can be opened by swiping from the left edge of the screen
class HiddenDrawer extends StatefulWidget {
  
  const HiddenDrawer({super.key});


  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();

}

class _HiddenDrawerState extends State<HiddenDrawer> { 

  List<ScreenHiddenDrawer> _screens = [];
  
  @override
  void initState() {
    super.initState();

    _screens = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(name: 'Crop Growth', baseStyle: TextStyle(), selectedStyle: TextStyle()),
        Loading(),
      ),
       ScreenHiddenDrawer(
        ItemHiddenMenu(name: 'Field Details', baseStyle: TextStyle(), selectedStyle: TextStyle()),
        Loading(),
      ),
      // ScreenHiddenDrawer(
      //    ItemHiddenMenu(name: 'Field Insights', baseStyle: TextStyle(), selectedStyle: TextStyle()),
      //    FieldInsights(fieldId: widget.fieldId),
      // )
    ];
  }

  @override
  Widget build(BuildContext context) {

    return HiddenDrawerMenu(
      screens: _screens,   
      backgroundColorMenu: Colors.green.shade50,
      initPositionSelected: 0,
    );

  }

  }
