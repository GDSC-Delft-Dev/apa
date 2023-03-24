import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/insight_item_model.dart';
import 'package:frontend/providers/insight_types_provider.dart';
import 'package:frontend/stores/insight_item_store.dart';
import 'package:frontend/views/loading.dart';
import 'package:provider/provider.dart';
import '../../../models/insight_model.dart';

/// Builds the bottom sheet with details about localized insights
class InsightDetailsSheet extends StatelessWidget {
  final InsightModel insight;

  const InsightDetailsSheet({Key? key, required this.insight}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var insightType = Provider.of<InsightTypesProvider>(context, listen: false)
        .getInsightTypeById(insight.typeId);
        
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    return FutureBuilder<InsightItemModel>(
        future: InsightItemStore().getInsightItemByTypeId(insight.data, insightType.id),
        builder: (context, snapshot) {
          
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }

          var insightItem = snapshot.data!;

          return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                      child: Text(
                    '${capitalize(insightItem.name)} detected!',
                    style: TextStyle(fontSize: 20, color: Colors.red[900]),
                  )),
                  const SizedBox(height: 20),
                  // For pests we show area affected
                  insight.data['area'] > 0.0
                      ? Row(
                          children: [
                            Text(
                              'Area affected: ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${insight.data['area']} ha',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Details', style: TextStyle(fontSize: 18)),
                            Text(insightItem.description, style: TextStyle(fontSize: 14, color: Colors.grey[700])),  
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      CachedNetworkImage(
                        imageUrl: insight.data['image'],
                        width: 140.0,
                        height: 150.0,
                      )
                    ],
                  ),
                  const Text('Recommendations', style: TextStyle(fontSize: 18)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: insight.data['recommendations']
                          .cast<String>()
                          .map((String recommendation) => Text('\u2022 $recommendation',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700])))
                          .toList()
                          .cast<Widget>()),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        child: const Text(
                          "Close",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                  )
                ],
              ));
        });


  }
}
