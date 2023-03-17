import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/providers/field_scan_provider.dart';
import 'package:frontend/providers/insight_types_provider.dart';
import 'package:frontend/views/insights/widgets/color_legend.dart';
import 'package:frontend/views/insights/widgets/insight_details_sheet.dart';
import 'package:frontend/views/insights/widgets/menu_drawer_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/field_model.dart';
import 'package:frontend/utils/polygon_utils.dart' as utils;
import 'package:frontend/utils/network_utils.dart' as nutils;
import '../../../models/insight_model.dart';
import '../../../providers/insight_choices_provider.dart';
import '../../loading.dart';
import 'insights_selection.dart';
import 'maps_dropdown.dart';

/// This class builds the insight map chosen by user
class VisualizeInsightsMap extends StatefulWidget {
  final FieldModel currField;

  const VisualizeInsightsMap({super.key, required this.currField});

  @override
  State<VisualizeInsightsMap> createState() => _VisualizeInsightsMapState();
}

class _VisualizeInsightsMapState extends State<VisualizeInsightsMap> {
  final Completer<GoogleMapController> _controller = Completer();

  // Workaround lagging screen due to Google Maps initialization
  final Future _mapFuture = Future.delayed(const Duration(milliseconds: 250), () => true);

  // For keeping track of polygons to  draw
  Set<Polygon> _polygons = Set<Polygon>();

  // For keeping track of insights to show
  Set<Marker> _insightMarkers = Set<Marker>();

  /// Takes a list of field models and created polygons to draw on the map
  void _drawInsightMap(InsightMapType mapType) {
    // Convert from List<GeoPoint> to List<LatLng>
    List<LatLng> fieldBoundaries =
        widget.currField.boundaries.map((f) => LatLng(f.latitude, f.longitude)).toList();
    _polygons.clear();
    _polygons.add(Polygon(
      polygonId: PolygonId(widget.currField.fieldId),
      points: fieldBoundaries,
      strokeColor: mapType == InsightMapType.ndvi ? Colors.orange : Colors.blue,
      strokeWidth: 5,
      fillColor: mapType == InsightMapType.ndvi ? Colors.orange : Colors.blue,
    ));
  }

  Future<BitmapDescriptor> fromUrlToBitmapDescriptor(String url) async {
    return BitmapDescriptor.fromBytes((await nutils.loadNetworkImage(url))!);
  }

  /// Takes a list of insights and creates markers to draw on the map
  Future<void> _drawMarkersForInsights(List<InsightModel> insights, List<String> excluded) async {
    _insightMarkers.clear();
    for (var insight in insights) {
      // Only show markers for insights that are selected by user
      if (!excluded.contains(insight.typeId)) {
        var bitmapDescriptor = await fromUrlToBitmapDescriptor(
            Provider.of<InsightTypesProvider>(context, listen: false)
                .getInsightTypeById(insight.typeId)
                .icon);
        _insightMarkers.add(
          Marker(
            markerId: MarkerId(Random().nextInt(100000).toString()),
            position: LatLng(insight.center.latitude, insight.center.longitude),
            icon: bitmapDescriptor,
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
            anchor: const Offset(0.5, 0.5),
          ),
        );
      }
    }
  }

  Future<void> updateMap() async {
    _polygons.clear();
    InsightMapType mapType =
        Provider.of<InsightChoicesProvider>(context, listen: true).currInsightMapType;
    _drawInsightMap(mapType);
  }

  Future<void> updateMarkers() async {
    _insightMarkers.clear();
    List<String> excluded =
        Provider.of<InsightChoicesProvider>(context, listen: true).excludedInsightsTypes;
    var scan = Provider.of<FieldScanProvider>(context, listen: true).selectedFieldScan;
    List<InsightModel> insights = scan == null ? <InsightModel>[] : scan.insights;

    await _drawMarkersForInsights(insights, excluded);
  }

  @override
  Widget build(BuildContext context) {
    updateMap();
    return Scaffold(
      body: FutureBuilder(
          future: updateMarkers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Loading();
            }
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        myLocationEnabled: false,
                        initialCameraPosition:
                            utils.getGoodCameraPositionForPolygon(widget.currField.boundaries),
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
                            InsightsSelection(),
                            SizedBox(height: 10),
                            MenuDrawerButton(),
                            // HiddenDrawer()
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20, right: 10, left: 170),
                          alignment: Alignment.topRight,
                          child: const MapsDropdown()),
                      Container(
                        padding: const EdgeInsets.only(bottom: 70, right: 10, left: 10),
                        alignment: Alignment.bottomCenter,
                        child: const ColorLegend(mapType: 'NDVI')
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
