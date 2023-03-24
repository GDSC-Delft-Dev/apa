import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const MyBottomNavigationBar({super.key, required this.currentIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onItemSelected,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          iconSize: 28,
          elevation: 24,
          // make it have rounded corners
          type: BottomNavigationBarType.shifting,


          items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
            backgroundColor: Colors.white,),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: 'Fields',
            backgroundColor: Colors.white,),
          BottomNavigationBarItem(icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.white),
        ]
    );
  }
}