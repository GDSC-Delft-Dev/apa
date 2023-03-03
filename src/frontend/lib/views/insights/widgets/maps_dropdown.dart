// import 'package:flutter/material.dart';

// class MapsDropdown extends StatefulWidget {

//   const MapsDropdown({super.key });

//   @override
//   State<MapsDropdown> createState() => _MapsDropdownState();
// }


// class _MapsDropdownState extends State<MapsDropdown> {

//  @override
//   Widget build(BuildContext context) { 
//     return DropdownButton(
//         value: currInsightMapType,
//         icon: const Icon(Icons.arrow_downward),
//         underline: Container(
//           height: 2,
//           color: Colors.deepPurpleAccent),
//         items: InsightMapTypes.values.map((InsightMapTypes type) {
//           return DropdownMenuItem<InsightMapTypes>(
//             value: type,
//             child: Text(type.toString()),
//           );
//         }).toList(),
//         onChanged: (InsightMapTypes? value) {
//           setState(() {
//             currInsightMapType = value;
//           });
//         },
//        )
//  }

// }