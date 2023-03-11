import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/models/scan_model.dart';
import 'package:frontend/stores/scan_store.dart';

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
    print(widget.fieldModel.runs);
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return FutureBuilder<List<ScanModel>>(
            future: ScanStore().getScanDetailsList(widget.fieldModel.runs),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print(snapshot.error);
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Center(
                      child: Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                      ),
                    ),
                    // Horizontal scrolling list of crops
                  ],
                ),
              );
            });
      },
      initialChildSize: 0.1,
      minChildSize: 0.1,
    );
  }
}
