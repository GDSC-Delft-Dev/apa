import 'package:flutter/material.dart';
import '../../../models/insight_model.dart';


/// Builds the bottom sheet with details about localized insights
class InsightDetailsSheet extends StatelessWidget {

  final InsightModel insight;

  const InsightDetailsSheet({Key? key, required this.insight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
        mainAxisSize: MainAxisSize.min,  // To make the card compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(child: Text('${insight.getName} detected!', style: TextStyle(fontSize: 20, color: Colors.red[900]),)),
          SizedBox(height: 20),
          Row (
            children: [
              Text('Date: ', style: TextStyle(fontSize: 18),),
              Text('${insight.getDate}', style: TextStyle(fontSize: 14, fontFamily: 'Lato'),),
            ],),
          // For pests we show area affected
          insight.getArea > 0.0 ? Row (
            children: [
              Text('Area affected: ', style: TextStyle(fontSize: 18),),
              Text('${insight.getArea} ha', style: TextStyle(fontSize: 14, fontFamily: 'Lato'),),
            ],) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details', style: TextStyle(fontSize: 18)),
                  Text('${insight.getDetails}', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Lato')),
                  insight.getProperName != '' ? 
                    Text('Scientific name: ${insight.getProperName}', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Lato')) 
                    : Container(),
                ],
              ),
              ),
              SizedBox(width: 10),
              Image.asset('${insight.getImage}', width: 100.0, height: 100.0,)
            ],
          ),
          Text('Recommendations', style: TextStyle(fontSize: 18)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: insight.getRecommendations.map((recommendation) => 
                  Text('\u2022 $recommendation', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Lato'))).toList()
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              child: Text("Close", style: TextStyle(fontSize: 16),),
              onPressed: () => Navigator.of(context).pop()),
          )
        ],
        )
      );
  }
}
