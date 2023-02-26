import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/stores/fields_store.dart';
import 'package:frontend/views/addfield/widgets/custom_app_bar.dart';
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
    final user = Provider.of<UserModel>(context);

    return StreamProvider<List<FieldModel>>.value(
      value: FieldsStore(userId: user.uid).fields,
      initialData: const [],
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(241, 244, 248, 1),
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 150,
                  height: 200,
                  color: Colors.green,
                ),
                SizedBox.fromSize(
                  size: const Size.fromHeight(10),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Text(
                            "Field Name",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade700,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.05,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _fieldNameController,
                            decoration: const InputDecoration(
                                hintText: 'e.g. Field 1',
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Text(
                            "Crop type",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade700,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.05,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _cropTypeController,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Wheat',
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size.fromHeight(20),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                  SizedBox(
                    width: 275,
                    height: 50,
                    child: RoundedButton(onPressed: () {}, text: "Save Field", color: Colors.green),
                  ),
                  SizedBox(
                    width: 275,
                    height: 50,
                    child: RoundedButton(
                        onPressed: () {}, text: "Save Field and fly drone", color: Colors.blue),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const RoundedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
