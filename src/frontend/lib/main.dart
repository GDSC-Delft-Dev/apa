import 'package:flutter/material.dart';
import 'package:frontend/views/home.dart';
import 'package:frontend/views/addfield.dart';
import 'package:frontend/views/loading.dart';
import 'package:frontend/views/myfields.dart';
import 'package:frontend/views/flydrone.dart';
import 'package:frontend/views/settings.dart';
import 'package:frontend/widgets/bottom_navbar_widget.dart';
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
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: currIndex,
        onItemSelected: (idx) => setState(() => currIndex = idx),
      ),
    );
  }

}
