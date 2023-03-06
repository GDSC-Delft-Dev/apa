import 'package:flutter/material.dart';
import 'package:frontend/views/home/widgets/visualize_home_map.dart';
import 'package:provider/provider.dart';

import '../../models/field_model.dart';
import '../../models/user_model.dart';
import '../../stores/fields_store.dart';
import '../addfield/add_field_screen.dart';

/// This is the first screen within the application that the user encounters
/// It contains a Google Map to indicate all fields owned by the user
class Home extends StatefulWidget {

  const Home({super.key, required this.title});

  final String title;

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    // Curent user that is logged in
    final user = Provider.of<UserModel>(context);

    return StreamProvider<List<FieldModel>>.value(
      value: FieldsStore(userId: user.uid).fields,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: const VisualizeHomeMap(),
        floatingActionButton: FloatingActionButton(
          heroTag: 'home_add',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFieldScreen(),
              )
            );
          },
          tooltip: 'Add field',
          child: const Icon(Icons.add, size: 35, color: Colors.white,)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat
      ),
    );

  }

}


