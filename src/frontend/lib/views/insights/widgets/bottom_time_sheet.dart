import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/models/scan_model.dart';
import 'package:frontend/providers/field_scan_provider.dart';
import 'package:frontend/stores/scan_store.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BottomTimeSheet extends StatefulWidget {
  const BottomTimeSheet({
    super.key,
    required this.fieldModel,
  });
  final FieldModel fieldModel;
  @override
  State<BottomTimeSheet> createState() => _BottomTimeSheetState();
}

class _BottomTimeSheetState extends State<BottomTimeSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        var selectedFieldScan = Provider.of<FieldScanProvider>(context).selectedFieldScan;
        return selectedFieldScan == null ? const SizedBox.shrink() : Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                decoration:  BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button to change selected field scan
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: Provider.of<FieldScanProvider>(context, listen: true).isFirstFieldScan()? null : () {
                              Provider.of<FieldScanProvider>(context, listen: false).selectPreviousFieldScan();
                            },
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(selectedFieldScan.endDate),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: Provider.of<FieldScanProvider>(context, listen: true).isLastFieldScan()? null : () {
                              Provider.of<FieldScanProvider>(context, listen: false).selectNextFieldScan();
                            },
                          ),
                        ],
                      ),
                    ),
                    // Horizontal scrolling list of crops
                  ],
                ),
              
            );
      },
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.1,
    );
  }
}
