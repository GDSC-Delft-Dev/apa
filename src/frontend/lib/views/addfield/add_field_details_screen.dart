import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/new_field_provider.dart';
import 'package:frontend/views/addfield/widgets/add_field_info_card.dart';
import 'package:frontend/views/addfield/widgets/visualize_field_map.dart';
import 'package:frontend/widgets/terrafarm_app_bar.dart';
import 'package:frontend/widgets/terrafarm_rounded_button.dart';
import 'package:provider/provider.dart';

class AddFieldDetailsScreen extends StatefulWidget {
  final List<GeoPoint> polygon;

  const AddFieldDetailsScreen({super.key, required this.polygon});

  @override
  State<AddFieldDetailsScreen> createState() => _AddFieldDetailsScreenState();
}

class _AddFieldDetailsScreenState extends State<AddFieldDetailsScreen> {
  // adding the text editing controller
  late TextEditingController _fieldNameController;
  late TextEditingController _cropTypeController;

  @override
  void initState() {
    super.initState();
    _fieldNameController = TextEditingController();
    _cropTypeController = TextEditingController();
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
                        polygon: Provider.of<NewFieldProvider>(context).getPolygon(),
                        // Gets a good camera position.
                        cameraPosition: Provider.of<NewFieldProvider>(context)
                            .getGoodCameraPositionForPolygon(),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: const Size.fromHeight(10),
                    ),
                    AddFieldInfoCard(
                      textController: _fieldNameController,
                      hintText: "e.g. Field 1",
                      text: "Field Name",
                    ),
                    AddFieldInfoCard(
                        textController: _cropTypeController,
                        hintText: "e.g. Wheat",
                        text: "Crop Type"),
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
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: 275,
                    height: 50,
                    child: TerrafarmRoundedButton(
                        onPressed: () {}, text: "Save field", color: Colors.green),
                  ),
                  SizedBox(
                    width: 275,
                    height: 50,
                    child: TerrafarmRoundedButton(
                        onPressed: () {}, text: "Save field and fly drone", color: Colors.blue),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
