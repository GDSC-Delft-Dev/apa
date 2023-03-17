import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';


class ColorLegend extends StatelessWidget {

  final String mapType;

  const ColorLegend({super.key, required this.mapType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.redAccent],
                    begin: Alignment.centerLeft, end: Alignment.centerRight, tileMode: TileMode.clamp)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 250.0),
            child: Text('Min', style: TextStyle(fontSize: 15.0, color: Colors.black),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('Max', style: TextStyle(fontSize: 15.0, color: Colors.black),),
        )
      ],),
    );
  }
}