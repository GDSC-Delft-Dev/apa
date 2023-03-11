import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/insight_types_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/insight_model.dart';


/// Builds the bottom sheet with details about localized insights
class InsightDetailsSheet extends StatelessWidget {

  final InsightModel insight;

  const InsightDetailsSheet({Key? key, required this.insight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var insightType = Provider.of<InsightTypesProvider>(context, listen: false).getInsightTypeById(insight.typeId);
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
        mainAxisSize: MainAxisSize.min,  // To make the card compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(child: Text('${insightType.name} detected!', style: TextStyle(fontSize: 20, color: Colors.red[900]),)),
          const SizedBox(height: 20),
          // For pests we show area affected
          5 > 0.0 ? Row (
            children: [
              Text('Area affected: ', style: TextStyle(fontSize: 18),),
              Text('${5} ha', style: TextStyle(fontSize: 14, fontFamily: 'Lato'),),
            ],) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details', style: TextStyle(fontSize: 18)),
                  Text('${insight.data}', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Lato')),
                  insightType.name != '' ? 
                    Text('Scientific name: ${insightType.name}', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Lato')) 
                    : Container(),
                ],
              ),
              ),
              SizedBox(width: 10),
              CachedNetworkImage(imageUrl: insightType.icon, width: 100.0, height: 100.0,)
            ],
          ),
          Text('Recommendations', style: TextStyle(fontSize: 18)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: insightType.recommendations.map((recommendation) => 
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
