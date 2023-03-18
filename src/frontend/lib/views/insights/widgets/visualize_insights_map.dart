import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/insight_type_model.dart';
import 'package:frontend/models/scan_model.dart';
import 'package:frontend/providers/field_scan_provider.dart';
import 'package:frontend/providers/insight_types_provider.dart';
import 'package:frontend/utils/network_utils.dart';
import 'package:frontend/utils/polygon_utils.dart';
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
import 'bottom_insights_sheet.dart';
import 'hidden_drawer.dart';
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
  BitmapDescriptor? _overlayImage;
  double _bearing = 0;
  double _transparency = 0;

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
    print('updated map');
  }

  Future<void> updateMarkers() async {
    _insightMarkers.clear();
    List<String> excluded =
        Provider.of<InsightChoicesProvider>(context, listen: true).excludedInsightsTypes;
    var scan = Provider.of<FieldScanProvider>(context, listen: true).selectedFieldScan;
    List<InsightModel> insights = scan == null ? <InsightModel>[] : scan.insights;

    await _drawMarkersForInsights(insights, excluded);
  }

  void _removeGroundOverlay() {
    setState(() {
      _overlayImage = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _addGroundOverlay();
  }

  Future<void> _addGroundOverlay() async {
    var bytes = await loadNetworkImage(
        'https://fff2df98a796d7e3d5d805ed2415c1f937f282bb453e636936006b2-apidata.googleusercontent.com/download/storage/v1/b/terrafarm-scans/o/xHv2bv9rPdrYav79FfFK%2F03-2022%2Fc6bd6bf3-8ea9-40f3-ac73-cd46521a5270%2Fpipelines%2Fa0f2ce2e-46e1-4e2d-9436-ca63a7a3c4f5%2Findex%2Frgb%2Fdownscaled.png?jk=AahUMlsvriKtyWN9gP1FrG4dK6LvJ9pjzPwTc-dbmADSEzu-6dMq78qN3zLB98_EdGSoQp1LxTvUmwws088eV4JzbMQfsstB3WTloH8UAn7bOF-IjCSiwFigtcZqcWCylJhXzTcRGKeigFrqCKlLT_zj4WtdwVufo4e8cOlTiJSnj-BBmHAp3eRttfqqn2WGBx9mr4aV1_Y9luftiMmuMAdG5JPxHh4fBLvgYjfFr9ZqG6ymifw18_zkBckOt7QWS5m4oa-ntT2XR81jQWOQBY1cRNvIkhngHBgHW6d4GmF0B4auOYeRpYiYCPq5nK-u3aknpNM7sqPySiuddLzwA0TUVXSwVLAB_T5zO-VKodTpl0jLTwbZ7IqdnOetRlBe2WbLnCmnVo6YK27fuL62Y57iol0EvsCjU1S5amc58kw5KkxzxpybBlbteMiFrgw80pweFTmP4hZDVX2q9yICYvkFlUqHZSAgVHwtzaafcXIJb8zOYZfz0d_HUE3SbDqSsCmurx_xkbApDj4pKw9O3kYV5dz73HtBYlVO5bbW7bHVgiPlGhunZuem1-BY9cbr9q66einSPK0mt5O9Qxy6gDF2YfJocVIDbH0fJiGsmndQnz62alHjKIvpnlJBEoeQ2IwzxYjQOzMKN3stEKBO9bWv7tXHkynonKvo4lS1rQedQZLCwbbJzYdJ1aFwbyh8JrCK0hCOVe7yTB7d2LtyuBR49NAIufY0RA1G2qx_7PErnfFwD5AfFQ8VAuZ0ja4FDBlK2WhA7JP6GaXgXbtgB9MpKAe0Y9a0nUyWKYGe95BIfn0sl4UqiOT0RY9I2gLj_kMNnX7J1vqp3nEnZOk9YHnCKOZ6AHWq-F-aebt7NCwBDaJlXN-3ZLPvlQjOvVrnynU0rNTA4XWFe5hhYrw850XmJ7tD-eYf63bAxZkEFgVDINc8V3cSjjE_MWAe5GgjKf4yABGCPnsXBbXv3u72b0u15-vXYZXa-II_8VrVneB_itwVXWL70xMh6L89VloszVa9CgpggLxT9KjAUs2i2L8DYC15x4h2qipFjPBC3Jk9Vi6Ap3h7eL6eYo-QBLUzRrJQ2XYF0T391U_Y8jG-RaeZtJdURhzD7q8uPbs_haTFr-d36SuVVAqd_TTsx_iiDpJAmpFg-DTIHOA_Z5fbknBnErjPNVj6UWvCLWO2MwHOcTHxZYpUwlEO4oSGMAMVIBcbBYDmPQtNwsTkqpxYSIsv0SQb167gOWZMFh_5Vgk3i3Cx05hYmWwzK1CJo5-ZCQ6bEeMT5f8Scpv75n2czL-D5obb0lX31BYyKcYMH0lh0yRzpA6BLKo-bWYSbW44jei7p3LEgSwsQV7OjNGy0nQzPPD3G6w2Bzt42jSC8UwO2Wdi2ZnPfHqCaLnv8ULrhb-4oS8QFVBU0mSg-ZnAESWdcgd1-Yoe&isca=1');
    var bitmap = BitmapDescriptor.fromBytes(
      bytes!,
    );
    setState(() {
      _overlayImage = bitmap;
    });
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
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        myLocationEnabled: false,
                        groundOverlays: _overlayImage != null
                            ? {
                                GroundOverlay(
                                  groundOverlayId: GroundOverlayId('ground_overlay_1'),
                                  image: _overlayImage!,
                                  positionFromBounds: getLatLngBoundsForPolygon(widget.currField.boundaries),
                                  bearing: 0,
                                  transparency: 0,
                                  zIndex: 1,
                                ),
                              }
                            : Set(),
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
                    ],
                  ),
                )
                // TODO: Add color scale for insights
              ],
            );
          }),
    );
  }
}
