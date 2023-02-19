import 'package:flutter/material.dart';
import 'package:frontend/views/home/home.dart';
import 'package:frontend/views/myfields/my_fields.dart';
import 'package:frontend/views/flydrone/flydrone.dart';
import 'package:frontend/views/settings/settings.dart';
import 'package:frontend/widgets/bottom_navbar.dart';

/// Main screen that the user sees
/// Depending on the index that is selected by the user through icons in the bottom nav bar
class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currIndex = 0;
  final screens = [
    Home(title: 'APA'),
    MyFields(),
    FlyDrone(droneName: 'DJI Mavic 3'),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensures state of all children are preserved
      body: IndexedStack(
        index: currIndex,
        children: screens,
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: currIndex,
        onItemSelected: (idx) => setState(() => currIndex = idx),
      ),
    );
  }

}
