import 'package:flutter/material.dart';
import 'package:apa_app/views/home.dart';
import 'package:apa_app/views/addfield.dart';
import 'package:apa_app/views/loading.dart';
import 'package:apa_app/views/myfields.dart';
import 'package:apa_app/views/flydrone.dart';
import 'package:apa_app/views/settings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  // Allows env vars to be used in source code
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autonomous Precision Agriculture using UAVs',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/load': (context) => Loading(),
        '/home': (context) => const Home(title: 'APA'),
        '/add': (context) => const AddField(),
        '/fields': (context) => const MyFields(),
        '/fly': (context) => const FlyDrone(droneName: 'DJI Mavic 3',),
        '/settings': (context) => const Settings(),
      }

    );
  }
}

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
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currIndex,
          onTap: (idx) => setState(() => currIndex = idx),
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
      ),
    );
  }

}
