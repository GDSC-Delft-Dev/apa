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
        children: [
          SizedBox(height: 20),
          Text('${insight.getDetails} detected!', style: TextStyle(fontSize: 20, color: Colors.red[900]),),
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
