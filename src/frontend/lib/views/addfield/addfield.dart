import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:provider/provider.dart';

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

    // Stream listens for updates to 'Fields' collection
    return Scaffold(
        body: SafeArea(
          child:
            Center(
              child: ElevatedButton(
                    child: Text('Add dummy field'),
                    onPressed: () async => {
                      // TODO: add new field instead of updating
                      // TODO: fetch current user uid
                      await FieldsStore(userId: user.uid)
                          .addNewField("New spinach field", 12.3, "NlDfTwwMaYaVB1eTYYIkAdSDkMg1")
                    }
                )
            ),
        ),
    );
  }

}