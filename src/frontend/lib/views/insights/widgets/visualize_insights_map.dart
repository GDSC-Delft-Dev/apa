import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/field_model.dart';
import '../../loading.dart';

class VisualizeInsightsMap extends StatefulWidget {

  final String currFieldId;

  const VisualizeInsightsMap({super.key, this.currFieldId = ''});

  @override
  State<VisualizeInsightsMap> createState() => _VisualizeInsightsMapState();
}

class _VisualizeInsightsMapState extends State<VisualizeInsightsMap> {

  final Completer<GoogleMapController> _controller = Completer();

  // Workaround lagging screen due to Google Maps initialization
  final Future _mapFuture = Future.delayed(
      const Duration(milliseconds: 250), () => true);



  @override
  Widget build(BuildContext context) {
    // Refers to the StreamProvider of parent widget Home()
    // TODO: use current field id to get: field name, field insights, field borders
    final fields = Provider.of<List<FieldModel>>(context);

    return Scaffold(
      body: FutureBuilder(
        future: _mapFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          return Column(
            children: [
              // TODO: only display current field (use formula)
              Consumer<MapSettingsProvider>(
                  builder: (context, mapSettings, child) {
                    return Expanded(
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            mapToolbarEnabled: false,
                            // TODO: if field insight, keep static/zoomed view of current field
                            initialCameraPosition: mapSettings.cameraPosition,
                            mapType: mapSettings.mapType,
                            // TODO: Show localized insights with markers
                            // markers: {_exampleMarker},
                            // polygons: _polygons,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            onCameraMove: (camera) =>
                                mapSettings.setCameraPosition(camera),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 25, right: 12),
                            alignment: Alignment.topRight,
                            child: Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  backgroundColor: Colors.blueAccent[100],
                                  onPressed: mapSettings.toggleMapType,
                                  child: const Icon(Icons.map_rounded),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 95, right: 12),
                            alignment: Alignment.topRight,
                            child: Column(
                              children: <Widget>[
                                const FloatingActionButton(
                                    backgroundColor: Colors.lightGreenAccent,
                                    // TODO: Allow user to pick insight maps
                                    onPressed: null,
                                    child: Icon(
                                        Icons.stacked_line_chart_rounded))
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 165, right: 12),
                            alignment: Alignment.topRight,
                            child: Column(
                              children: <Widget>[
                                FloatingActionButton(
                                    backgroundColor: Colors.orange,
                                    onPressed: null,
                                    child: const Icon(
                                        Icons.warning_amber_rounded)
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
              ),
            ],
          );
        },
      ),
    );
  }
}

