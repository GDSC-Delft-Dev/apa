import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:frontend/views/map.dart';
import 'package:provider/provider.dart';

import '../../models/field_model.dart';
import '../../models/user_model.dart';

/// This screen allows users to add fields (by drawing borders e.g.)
class AddField extends StatefulWidget {

  const AddField({super.key});

  @override
  _AddFieldState createState() => _AddFieldState();
}

class _AddFieldState extends State<AddField> {

  @override
  Widget build(BuildContext context) {

    // Curent user that is logged in
    final user = Provider.of<UserModel>(context);

    List<GeoPoint> exampleGeopoints = [
      GeoPoint(51.987308, 4.324069),
      GeoPoint(51.987179, 4.321984),
      GeoPoint(51.982814, 4.318815),
      GeoPoint(51.980851, 4.319083),
      GeoPoint(51.981906, 4.325687)
    ];

    // Stream listens for updates to 'Fields' collection
    return StreamProvider<List<FieldModel>>.value(
      value: FieldsStore(userId: user.uid).fields,
      initialData: [],
      child: Scaffold(
          body: SafeArea(
            child:
              Center(
                child: MyMap(context: 'Add')
                // child: ElevatedButton(
                //       child: Text('Add dummy field'),
                //       onPressed: () async => {
                //         await FieldsStore(userId: user.uid)
                //             .addNewField("New corn field", 12.3, exampleGeopoints)
                //       }
                //   )
              ),
          ),
      ),
    );
  }

}