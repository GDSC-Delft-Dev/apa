import 'package:flutter/material.dart';
import 'package:frontend/models/crop.dart';

class AddFieldCropType extends StatefulWidget {
  AddFieldCropType({super.key, required this.onChange, required this.text});

  final String text;
  final Function(CropType) onChange;

  @override
  State<AddFieldCropType> createState() => _AddFieldCropTypeState();
}

class _AddFieldCropTypeState extends State<AddFieldCropType> {
  String? cropType = null;

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
                  fontFamily: 'Roboto',
                  letterSpacing: 0.05,
                ),
              ),
            ),
            Expanded(
              // Combobox
              child: DropdownButton<String>(
                  items: CropType.values.map((CropType cropType) {
                    return DropdownMenuItem<String>(
                      value: cropType.toString(),
                      child: Center(child: Text(cropType.name.toString())),
                    );
                  }).toList(),
                  value: cropType,
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
                    widget.onChange(CropType.values
                        .firstWhere((CropType cropType) => cropType.toString() == newValue));
                    cropType = newValue;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
