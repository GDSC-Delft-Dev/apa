import 'package:flutter/material.dart';
import 'package:frontend/models/crop_model.dart';
import 'package:frontend/stores/crop_store.dart';

class AddFieldCropType extends StatefulWidget {
  AddFieldCropType({super.key, required this.onChange, required this.text});

  final String text;
  final Function(String) onChange;

  @override
  State<AddFieldCropType> createState() => _AddFieldCropTypeState();
}

class _AddFieldCropTypeState extends State<AddFieldCropType> {
  String? cropId = null;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                widget.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.05,
                ),
              ),
            ),
            StreamBuilder<List<CropModel>>(
                stream: CropStore().crops,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  return Expanded(
                    // Combobox
                    child: DropdownButton<String>(
                        items: snapshot.hasData
                            ? snapshot.data!.map((CropModel crop) {
                                return DropdownMenuItem<String>(
                                  value: crop.cropId,
                                  child: Center(child: Text(crop.name.toString())),
                                );
                              }).toList()
                            : [],
                        value: cropId,
                        hint: Text('Select a crop type'),
                        icon: Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.arrow_downward),
                          ),
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black45, fontSize: 18),
                        onChanged: (String? newValue) {
                          widget.onChange(newValue!);
                          setState(() {
                            cropId = newValue;
                          });
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
