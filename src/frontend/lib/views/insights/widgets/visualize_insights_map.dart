import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/menu_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/field_model.dart';
import 'package:frontend/utils/polygon_utils.dart' as utils;
import '../../loading.dart';


enum InsightMapTypes { 
  ndvi, 
  soilMoisture 
}
/// This class builds the insight map chosen by user
class VisualizeInsightsMap extends StatefulWidget {

  final FieldModel currField;

  const VisualizeInsightsMap({super.key, required this.currField });

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
  InsightMapTypes currInsightMapType = InsightMapTypes.ndvi;

  /// Takes a list of field models and created polygons to draw on the map
  _drawInsightMap(InsightMapTypes mapType) {    
    // Convert from List<GeoPoint> to List<LatLng>
    List<LatLng> fieldBoundaries = widget.currField.boundaries.map((f) =>
          LatLng(f.latitude, f.longitude)).toList();
      _polygons.clear();
      _polygons.add(
          Polygon(
              polygonId: PolygonId(widget.currField.fieldId),
              points: fieldBoundaries,
              strokeColor: mapType == InsightMapTypes.ndvi ? Colors.orange : Colors.blue,
              strokeWidth: 5,
              fillColor: mapType == InsightMapTypes.ndvi ? Colors.orange : Colors.blue,
          )
      );
    }



  @override
  Widget build(BuildContext context) {  

    _drawInsightMap(currInsightMapType);

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
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: const <Widget>[
                              MenuDrawer()
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30, right: 60, left: 170),
                          alignment: Alignment.topRight,
                          // TODO: Move to separate widget
                          child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: currInsightMapType.toString().split('.').last,
                                    ),
                                    value: currInsightMapType,
                                    icon: const Icon(Icons.arrow_downward),
                                    items: InsightMapTypes.values.map((InsightMapTypes type) {
                                      return DropdownMenuItem<InsightMapTypes>(
                                        value: type,
                                        child: Text(type.toString().split('.').last, style: TextStyle(fontSize: 16)),
                                      );
                                    }).toList(),
                                    onChanged: (InsightMapTypes? value) {
                                      setState(() {
                                        currInsightMapType = value!;
                                        print('Changed to $currInsightMapType');
                                      });
                                      _drawInsightMap(value!);
                                    },
                          )
                        ),
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

