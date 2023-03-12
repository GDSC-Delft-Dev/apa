import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/storage/crop_growth_stages_storage.dart';

class GrowthStageVisualizer extends StatefulWidget {
  const GrowthStageVisualizer({
    super.key,
    required this.field,
  });
  final FieldModel field;

  @override
  State<GrowthStageVisualizer> createState() => _GrowthStageVisualizerState();
}

class _GrowthStageVisualizerState extends State<GrowthStageVisualizer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185,
      child: FutureBuilder<List<CachedNetworkImage>>(
        future: CropGrowthStagesStorage().getImagesCached(widget.field.cropId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong. Please try again later.'));
          }
          final List<CachedNetworkImage> images = snapshot.data!;
          return ListView(
            scrollDirection: Axis.horizontal,
            children: images
                .map(
                  (image) => Container(
                    margin:
                        EdgeInsets.only(right: images.indexOf(image) == images.length - 1 ? 0 : 15),
                    width: 125,
                    height: 175,
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 50,
                            height: 150,
                            child: image,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Growth stage ${images.indexOf(image) + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}