import 'package:flutter/material.dart';
import 'package:frontend/providers/field_scan_provider.dart';
import 'package:frontend/providers/field_view_provider.dart';
import 'package:frontend/providers/insight_choices_provider.dart';
import 'package:frontend/providers/insight_types_provider.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/authenticate/authenticate.dart';
import 'package:frontend/views/crop_growth/crop_growth_screen.dart';
import 'package:frontend/views/home/home.dart';
import 'package:frontend/views/addfield/add_field_screen.dart';
import 'package:frontend/views/loading.dart';
import 'package:frontend/views/myfields/my_fields.dart';
import 'package:frontend/views/flydrone/flydrone.dart';
import 'package:frontend/views/settings/settings.dart';
import 'package:frontend/views/wrapper.dart';
import 'package:frontend/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:frontend/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/new_field_provider.dart';

Future main() async {
  // Allows env vars to be used in source code
  final dotenvFuture = dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseFuture = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Parallelize loading of env vars and initializing Firebase
  await Future.wait([dotenvFuture, firebaseFuture]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {    
    Permission.location.request();
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: AuthService().user, // listens to auth state changes
          // All widgets within MaterialApp have access to user info
          initialData: UserModel(uid: ''),
        ),
        ChangeNotifierProvider<NewFieldProvider>(
          create: (_) => NewFieldProvider(),
        ),
        ChangeNotifierProvider<MapSettingsProvider>(
          create: (_) => MapSettingsProvider(),
        ),
        ChangeNotifierProvider<InsightChoicesProvider>(
          create: (_) => InsightChoicesProvider(),
        ),
        ChangeNotifierProvider<InsightTypesProvider>(
          create: (_) => InsightTypesProvider(),
        ),
        ChangeNotifierProvider<FieldScanProvider>(
          create: (_) => FieldScanProvider(),
        ),
        ChangeNotifierProvider<FieldViewProvider>(
          create: (_) => FieldViewProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Autonomous Precision Agriculture using UAVs',
        theme:
            ThemeData(primarySwatch: Colors.lightGreen, textTheme: GoogleFonts.openSansTextTheme()),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/load': (context) => Loading(),
          '/home': (context) => const Home(title: 'Terrafarm'),
          '/add': (context) => const AddFieldScreen(),
          '/fields': (context) => const MyFields(),
          '/login': (context) => Authenticate(),
          // TODO: add crop growth screen
          '/crop_growth': (context) => CropGrowthScreen(),
          // TODO: add field details screen
          '/field_details': (context) => Loading(),
          '/settings': (context) => const Settings(),
        },
      ),
    );
  }
}
