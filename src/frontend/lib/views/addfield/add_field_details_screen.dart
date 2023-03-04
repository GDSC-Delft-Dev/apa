import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/crop_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/new_field_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:frontend/views/addfield/widgets/add_field_crop_type.dart';
import 'package:frontend/views/addfield/widgets/add_field_info_card.dart';
import 'package:frontend/views/addfield/widgets/visualize_field_map.dart';
import 'package:frontend/widgets/terrafarm_app_bar.dart';
import 'package:frontend/widgets/terrafarm_rounded_button.dart';
import 'package:frontend/utils/polygon_utils.dart' as utils;
import 'package:provider/provider.dart';
import 'package:frontend/utils/polygon_utils.dart';

class AddFieldDetailsScreen extends StatefulWidget {
  const AddFieldDetailsScreen({super.key});

  @override
  State<AddFieldDetailsScreen> createState() => _AddFieldDetailsScreenState();
}

class _AddFieldDetailsScreenState extends State<AddFieldDetailsScreen> {
  // adding the text editing controller
  late TextEditingController _fieldNameController;
  String? _cropId = null;

  @override
  void initState() {
    super.initState();
    _fieldNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 244, 248, 1),
      appBar: TerraFarmAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: "Add Field Details",
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      height: 250,
                      child: VisualizeFieldMap(
                        // Gets the polygon to visualize from the provider.
                        polygon: Provider.of<NewFieldProvider>(context).getPolygon(
                          fillColor: Colors.green.withOpacity(0.5),
                          strokeColor: Colors.green,
                        ),
                        // Gets a good camera position.
                        cameraPosition: utils.getGoodCameraPositionForPolygon(Provider.of<NewFieldProvider>(context).geoPoints),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: const Size.fromHeight(10),
                    ),
                    AddFieldInfoCard(
                      textController: _fieldNameController,
                      onChange: () {
                        setState(() {});
                      },
                      hintText: "e.g. Field 1",
                      text: "Field Name",
                    ),
                    AddFieldCropType(
                      text: "Crop Type",
                      onChange: (crop) {
                        setState(() {
                          _cropId = crop;
                        });
                      },
                    ),
                    SizedBox.fromSize(
                      size: const Size.fromHeight(20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  _fieldNameController.text.isEmpty
                      ? "Please enter a field name"
                      : _cropId == null
                          ? "Please select a crop type"
                          : "Ready to save",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _fieldNameController.text.isEmpty
                        ? Colors.red
                        : _cropId == null
                            ? Colors.red
                            : Colors.green,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.05,
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size.fromHeight(10),
                ),
                SizedBox(
                  height: 50,
                  child: TerrafarmRoundedButton(
                      onPressed: _fieldNameController.text.isEmpty || _cropId == null
                          ? () {}
                          : () {
                              var userId = Provider.of<UserModel>(context, listen: false).uid;
                              FieldsStore(userId: userId)
                                  .addNewField(
                                      _fieldNameController.text,
                                      _cropId!,
                                      getGeoArea(
                                          Provider.of<NewFieldProvider>(context, listen: false)
                                              .geoPoints),
                                      Provider.of<NewFieldProvider>(context, listen: false)
                                          .geoPoints)
                                  .onError((error, stackTrace) {
                                // Snackbars are used to display messages to the user.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }).then((value) {
                                // Snackbars are used to display messages to the user.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Field added successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // Navigate to the home screen.
                                Navigator.popUntil(context, (route) => route.isFirst);
                              });
                            },
                      text: "Save field",
                      color: _fieldNameController.text.isEmpty || _cropId == null
                          ? Colors.grey
                          : Colors.green),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
