import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/providers/field_view_provider.dart';
import 'package:frontend/storage/crop_growth_stages_storage.dart';
import 'package:frontend/stores/crop_store.dart';
import 'package:frontend/views/crop_growth/widgets/growth_chart.dart';
import 'package:frontend/views/crop_growth/widgets/growth_stage_visualizer.dart';
import 'package:frontend/views/loading.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';

class CropGrowthScreen extends StatefulWidget {
  const CropGrowthScreen({super.key});

  @override
  State<CropGrowthScreen> createState() => _CropGrowthScreenState();
}

class _CropGrowthScreenState extends State<CropGrowthScreen> {
  @override
  Widget build(BuildContext context) {
    var field = Provider.of<FieldViewProvider>(context).field;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Growth'),
      ),
      body: field == null
          ? Loading()
          : Center(
              child: FutureBuilder<CropModel>(
                  future: CropStore().getCropById(field.cropId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done ||
                        snapshot.hasData == false) {
                      return Loading();
                    }

                    var crop = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                      // TODO: Replace with actual image
                                      image: CachedNetworkImageProvider(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Vegetable-Carrot-Bundle-wStalks.jpg/330px-Vegetable-Carrot-Bundle-wStalks.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${crop.name.toUpperCase()} field",
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Center(child: const Text("Crop stages", style: TextStyle(fontSize: 20))),
                          const SizedBox(height: 10),
                          GrowthStageVisualizer(
                            field: field,
                          ),
                          const SizedBox(height: 40),
                          GrowthChart(),
                        ],
                      ),
                    );
                  }),
            ),
    );
  }
}


