import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/new_field_provider.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:frontend/views/addfield/add_field_details_screen.dart';
import 'package:frontend/views/addfield/widgets/add_field_map.dart';
import 'package:frontend/views/addfield/widgets/bottom_bar_add_field.dart';
import 'package:frontend/widgets/terrafarm_app_bar.dart';
import 'package:frontend/views/map.dart';
import 'package:provider/provider.dart';

import '../../models/field_model.dart';
import '../../models/user_model.dart';

class AddFieldScreen extends StatefulWidget {
  const AddFieldScreen({super.key});

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<NewFieldProvider>(context, listen: false).clearGeoPoints();
  }
  @override
  Widget build(BuildContext context) {
    // Curent user that is logged in
    final user = Provider.of<UserModel>(context);

    // Stream listens for updates to 'Fields' collection
    return StreamProvider<List<FieldModel>>.value(
      value: FieldsStore(userId: user.uid).fields,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TerraFarmAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Add new field',
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Text(
                  "Draw borders for your desired field to be added.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.05,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      //Here goes the same radius, u can put into a var or function
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x54000000),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), child: const AddFieldMap()),
                  ),
                ),
                BottomBarAddField(
                  onPressed: (Provider.of<NewFieldProvider>(context).isPolygonReady()
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddFieldDetailsScreen(polygon: []),
                            ),
                          )
                      : null),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
