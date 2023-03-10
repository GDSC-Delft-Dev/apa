import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/views/insights/widgets/insight_details_sheet.dart';
import 'package:frontend/views/insights/widgets/menu_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/field_model.dart';
import 'package:frontend/utils/polygon_utils.dart' as utils;
import '../../../models/insight_model.dart';
import '../../../providers/insight_choices_provider.dart';
import '../../loading.dart';
import 'maps_dropdown.dart';

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

  // For keeping track of insights to show
  Set<Marker> _insightMarkers = Set<Marker>();
  BitmapDescriptor _pestMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _diseaseMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _nutrientMarkerIcon = BitmapDescriptor.defaultMarker;


  /// Takes a list of field models and created polygons to draw on the map
  void _drawInsightMap(InsightMapType mapType) {    

    // Convert from List<GeoPoint> to List<LatLng>
    List<LatLng> fieldBoundaries = widget.currField.boundaries.map((f) =>
          LatLng(f.latitude, f.longitude)).toList();
      _polygons.clear();
      _polygons.add(
          Polygon(
              polygonId: PolygonId(widget.currField.fieldId),
              points: fieldBoundaries,
              strokeColor: mapType == InsightMapType.ndvi ? Colors.orange : Colors.blue,
              strokeWidth: 5,
              fillColor: mapType == InsightMapType.ndvi ? Colors.orange : Colors.blue,
          )
      );
    }

    /// Takes a list of insights and creates markers to draw on the map
    void _drawMarkersForInsights(List<InsightModel> insights, List<InsightType> choices) {

      _insightMarkers.clear();
      insights.forEach((insight) {
        // Only show markers for insights that are selected by user 
        if (choices.contains(insight.getType)) {
          _insightMarkers.add(
          Marker(
            markerId: MarkerId(insight.insightId),
            position: LatLng(insight.getCenter.latitude, insight.getCenter.longitude),
            icon: insight.getType == InsightType.disease ? _diseaseMarkerIcon : 
                  insight.getType == InsightType.pest ? _pestMarkerIcon : 
                  insight.getType == InsightType.nutrient ? _nutrientMarkerIcon : 
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            // Open bottom sheet with details about localized insight
            onTap: () => showModalBottomSheet(
              enableDrag: false,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              context: context, 
              builder: (context) => InsightDetailsSheet(insight: insight)),
            // infoWindow: InfoWindow(title: insight.getDetails),
            anchor: const Offset(0.5, 0.5)
          )
        );
        }
      });
    }

    /// Adds custom icons to be used for markers
    void _addCustomIcons() {
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/pest_marker.png")
             .then((icon) {setState(() => _pestMarkerIcon = icon);},
        );
        BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/disease_marker.png")
             .then((icon) {setState(() =>
              _diseaseMarkerIcon = icon);},
        );
          BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/nutrient_marker.png").then(
          (icon) {setState(() => _nutrientMarkerIcon = icon);},
        );
    }

  @override
  Widget build(BuildContext context) {  

    _addCustomIcons();
    final List<InsightModel> insights = Provider.of<List<InsightModel>>(context)
                                          .where((insight) => insight.fieldId == widget.currField.fieldId).toList();
    InsightMapType mapType = Provider.of<InsightChoicesProvider>(context, listen: false).currInsightMapType;
    List<InsightType> choices = Provider.of<InsightChoicesProvider>(context, listen: false).selectedInsights;


    _drawInsightMap(mapType);
    _drawMarkersForInsights(insights, choices);

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
                          zoomGesturesEnabled: true,	
                          scrollGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          initialCameraPosition: utils.getGoodCameraPositionForPolygon(widget.currField.boundaries),
                          mapType: MapType.satellite,
                          markers: _insightMarkers,
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
                          child: const MapsDropdown()
                        ),
                      ],
                    ),
                  )
              // TODO: Add color scale for insights
            ],
          );
        },
      ),
    );
    
  }
}

