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
          Center(child: Text('${insight.getDetails} detected!', style: TextStyle(fontSize: 20, color: Colors.red[900]),)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('${insight.getCharacteristics}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ],
              ),
              ),
              SizedBox(width: 10),
              Image.asset('assets/images/black-spot-fungal-disease.jpg', width: 100.0, height: 100.0,)
            ],
          ),
          SizedBox(height: 12),
          Text('Recommendations', style: TextStyle(fontSize: 18)),
          SizedBox(height: 36),
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
