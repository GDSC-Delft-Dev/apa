import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/field_model.dart';
import '../../../stores/fields_store.dart';
import 'package:frontend/utils/polygon_utils.dart' as utils;
import '../../loading.dart';

class VisualizeInsightsMap extends StatefulWidget {

  final FieldModel currField;

  const VisualizeInsightsMap({super.key, required this.currField});

  @override
  State<VisualizeInsightsMap> createState() => _VisualizeInsightsMapState();
}

class _VisualizeInsightsMapState extends State<VisualizeInsightsMap> {

  final Completer<GoogleMapController> _controller = Completer();

  // Workaround lagging screen due to Google Maps initialization
  final Future _mapFuture = Future.delayed(
      const Duration(milliseconds: 250), () => true);

    // For keeping track of polygons to  draw
  Set<Polygon> _polygons = Set<Polygon>();

  /// Takes a list of field models and created polygons to draw on the map
  _convertCurrFieldToPolygon() {    
    // Convert from List<GeoPoint> to List<LatLng>
    List<LatLng> fieldBoundaries = widget.currField.boundaries.map((f) =>
          LatLng(f.latitude, f.longitude)).toList();
      _polygons.add(
          Polygon(
              polygonId: PolygonId(widget.currField.fieldId),
              points: fieldBoundaries,
              strokeColor: Colors.orange,
              strokeWidth: 5,
              fillColor: Colors.orange
          )
      );
    }

  @override
  Widget build(BuildContext context) {  

    _convertCurrFieldToPolygon();

    return Scaffold(
      body: FutureBuilder(
        future: _mapFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          return Column(
            children: [ 
              Expanded(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          mapToolbarEnabled: false,
                          // TODO: if field insight, keep static/zoomed view of current field
                          initialCameraPosition: utils.getGoodCameraPositionForPolygon(widget.currField.boundaries),
                          mapType: MapType.satellite,
                          // TODO: Show localized insights with markers
                          // markers: {_exampleMarker},
                          polygons: _polygons,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 45, right: 12),
                          alignment: Alignment.topRight,
                          child: Column(
                            children: const <Widget>[
                              FloatingActionButton(
                                  backgroundColor: Colors.lightGreenAccent,
                                  // TODO: Allow user to pick insight maps
                                  onPressed: null,
                                  child: Icon(
                                      Icons.stacked_line_chart_rounded))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 115, right: 12),
                          alignment: Alignment.topRight,
                          child: Column(
                            children: const <Widget>[
                              FloatingActionButton(
                                  backgroundColor: Colors.orange,
                                  onPressed: null,
                                  child: Icon(
                                      Icons.warning_amber_rounded)
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              // TODO: Add color scale for insights
              //TODO: Add option to visualize historical insights    
            ],
          );
        },
      ),
    );
  }
}

