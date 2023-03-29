import 'package:flutter/material.dart';
import 'package:frontend/providers/insight_choices_provider.dart';
import 'package:provider/provider.dart';

/// A dropdown menu that allows the user to select the type of map to display 
class MapsDropdown extends StatefulWidget {

  const MapsDropdown({super.key });

  @override
  State<MapsDropdown> createState() => _MapsDropdownState();
}


class _MapsDropdownState extends State<MapsDropdown> {

 @override
  Widget build(BuildContext context) { 

    InsightMapType currMap = Provider.of<InsightChoicesProvider>(context).currInsightMapType;

    return DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: currMap == InsightMapType.ndvi ? 'NDVI' 
                                        : currMap == InsightMapType.tcari ? 'TCARI'
                                        : currMap == InsightMapType.soilMoisture ? 'Soil Moisture'
                                        : currMap == InsightMapType.biomass ? 'Biomass'
                                        : currMap == InsightMapType.yield ? 'Yield'
                                        : 'Nitrogen',
              ),
              value: currMap,
              icon: const Icon(Icons.arrow_downward),
              items: InsightMapType.values.map((InsightMapType type) {
                return DropdownMenuItem<InsightMapType>(
                  value: type,
                  child: Text(type == InsightMapType.ndvi ? 'NDVI' 
                                        : type == InsightMapType.tcari ? 'TCARI'
                                        : type == InsightMapType.soilMoisture ? 'Soil Moisture'
                                        : type == InsightMapType.biomass ? 'Biomass'
                                        : type == InsightMapType.yield ? 'Yield'
                                        : 'Nitrogen'),
                );
              }).toList(),
              onChanged: (InsightMapType? value) {
                setState(() {
                  Provider.of<InsightChoicesProvider>(context, listen: false).setInsightMapType(value!);
                });
              },
    );
 }

}