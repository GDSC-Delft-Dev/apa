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
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
            backgroundColor: Colors.blueAccent,),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: 'My fields',
            backgroundColor: Colors.blueAccent,),
          BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active),
              label: 'Fly drone',
              backgroundColor: Colors.blueAccent),
          BottomNavigationBarItem(icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.blueAccent),
        ]
    );
  }
}