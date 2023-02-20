import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/home/home.dart';
import 'package:frontend/views/addfield/addfield.dart';
import 'package:frontend/views/loading.dart';
import 'package:frontend/views/myfields/my_fields.dart';
import 'package:frontend/views/flydrone/flydrone.dart';
import 'package:frontend/views/settings/settings.dart';
import 'package:frontend/views/wrapper.dart';
import 'package:frontend/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  // Allows env vars to be used in source code
  final dotenvFuture = dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseFuture = Firebase.initializeApp();
  // Parallelize loading of env vars and initializing Firebase
  await Future.wait([dotenvFuture, firebaseFuture]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user, // listens to auth state changes
      // All widgets within MaterialApp have access to user info
      initialData: UserModel(uid: ''),
      child: MaterialApp(
        title: 'Autonomous Precision Agriculture using UAVs',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/load': (context) => Loading(),
          '/home': (context) => const Home(title: 'Terrafarm'),
          '/add': (context) => const AddField(),
          '/fields': (context) => const MyFields(),
          '/fly': (context) => const FlyDrone(droneName: 'DJI Mavic 3',),
          '/settings': (context) => const Settings(),
        },
      ),
    );
  }
}
