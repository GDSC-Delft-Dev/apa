import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/crop_model.dart';
import 'package:frontend/stores/crop_store.dart';

class AddFieldPlantingDate extends StatefulWidget {
  AddFieldPlantingDate({super.key, required this.onChange, required this.text});

  final String text;
  final Function(String) onChange;

  @override
  State<AddFieldPlantingDate> createState() => _AddFieldPlantingDateState();
}

class _AddFieldPlantingDateState extends State<AddFieldPlantingDate> {
  Timestamp? plantingDate = null;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade800,
                  letterSpacing: 0.05,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton (
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900, 1),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    print('---------------------- picked: $picked');
                    setState(() {
                      plantingDate = Timestamp.fromDate(picked);
                    });
                    widget.onChange(plantingDate!.toDate().toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: plantingDate != null ? Colors.green : Colors.transparent,
                  onPrimary: Colors.white,
                ),
                child: plantingDate != null ? Text(plantingDate!.toDate().toString().substring(0, 11)) 
                                            : Text('Select date'),
              )
            )
          ],
        ),
      ),
    );
  }
}
