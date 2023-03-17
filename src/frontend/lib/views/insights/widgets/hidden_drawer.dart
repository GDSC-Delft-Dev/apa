import 'package:flutter/material.dart';
import 'package:frontend/views/insights/field_insights.dart';
import '../../loading.dart';


/// A widget that displays a hidden drawer that can be opened by swiping from the left edge of the screen
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          drawerItem(Icons.auto_graph_rounded, 'Crop growth', () => Navigator.pushNamed(context, '/crop_growth')),
          SizedBox(height: 12),
          drawerItem(Icons.manage_search_sharp, 'Field details', () => Navigator.pushNamed(context, '/field_details')),
          SizedBox(height: 12),
          drawerItem(Icons.settings, 'Settings', () => Navigator.pushNamed(context, '/settings')),
          SizedBox(height: 12),
          drawerItem(Icons.logout, 'Logout', () => Navigator.pushNamed(context, '/login'))
        ],
      )
    );
  }

  Widget drawerItem(IconData icon, String text, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () => onTap(),
      
    );
  }

}
