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

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    const String pestDesciption = "Long, tube-shaped body in small, rounded segments";
    const String diseaseDescription = "Feathery edged, black spots on lower leaves";
    const String deficiencyDescription = "Yellowing of leaves, especially on the lower edges";
    const List<String> pestRecommendations = ["Spray crops with solution of soap and water", "Create a habitat friendly to birds"];
    const List<String> diseaseRecommendations = ["Removal of fallen leaves and pruning infected canes", "Restrict irrigation during cloudy, humid weather", "Good air circulation"];
    const List<String> deficiencyRecommendations = ["Treat plants with a food rich in nitrogen", "Use an organic fertilizer or nitrate of soda", "Increase pH for better root absorption of nitrogen"];
      
    var insightType = Provider.of<InsightTypesProvider>(context, listen: false)
        .getInsightTypeById(insight.typeId);
    var currDescription = insightType.name == 'pest' ? pestDesciption : insightType.name == 'disease' ? diseaseDescription : deficiencyDescription;
    var currRecommendations = insightType.name == 'pest' ? pestRecommendations : insightType.name == 'disease' ? diseaseRecommendations : deficiencyRecommendations;
    var currImage = insightType.name == 'pest' ? 'https://firebasestorage.googleapis.com/v0/b/terrafarm-378218.appspot.com/o/insights_images%2Fcaterpillars-pest.jpg?alt=media&token=3ec649ee-fde8-4a5b-8f2f-2339191e9605' : insightType.name == 'disease' ? 'https://firebasestorage.googleapis.com/v0/b/terrafarm-378218.appspot.com/o/insights_images%2Fblack-spot-fungal-disease.jpg?alt=media&token=5056b4e8-82e1-4fe4-8c4e-d2b578a996a1' : 'https://firebasestorage.googleapis.com/v0/b/terrafarm-378218.appspot.com/o/insights_images%2Fnitrogen-deficiency.jpg?alt=media&token=0c8cdaf0-957c-454b-89d5-340b8e2d1031';
    var currInsightName = insightType.name == 'pest' ? 'Pest' : insightType.name == 'disease' ? 'Disease' : 'Nutrient Deficiency';

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
                    '$currInsightName detected!',
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
                            Text('Details', style: TextStyle(fontSize: 18)),
                            Text(currDescription, style: TextStyle(fontSize: 14, color: Colors.grey[700])),  
                            // insight.data.containsKey('proper_name')
                            //     ? Text('Scientific name: ${insight.data['proper_name']}',
                            //         style: TextStyle(fontSize: 14, color: Colors.grey[700]))
                            //     : Container(),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      CachedNetworkImage(
                        // imageUrl: insight.data['image'],
                        imageUrl: currImage,
                        width: 140.0,
                        height: 150.0,
                      )
                    ],
                  ),
                  Text('Recommendations', style: TextStyle(fontSize: 18)),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currRecommendations
                          .map((r) => Text('\u2022 $r',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700])))
                          .toList()
                          .cast<Widget>()),
                  // Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: insightItem['recommendations']
                  //         .cast<String>()
                  //         .map((String recommendation) => Text('\u2022 $recommendation',
                  //             style: TextStyle(fontSize: 14, color: Colors.grey[700])))
                  //         .toList()
                  //         .cast<Widget>()),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        child: Text(
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
