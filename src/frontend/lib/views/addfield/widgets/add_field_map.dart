import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';
import 'package:frontend/providers/map_settings_provider.dart';
import 'package:frontend/providers/new_field_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/views/loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddFieldMap extends StatefulWidget {
  const AddFieldMap({super.key});

  @override
  State<AddFieldMap> createState() => _AddFieldMapState();
}

class _AddFieldMapState extends State<AddFieldMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Polygon> _polygons = Set<Polygon>();
  
  _convertFieldsToPolygons(List<FieldModel> fields) {
    for (var field in fields) {
      List<LatLng> fieldBoundaries =
          field.boundaries.map((f) => LatLng(f.latitude, f.longitude)).toList();
      _polygons.add(
        Polygon(
          polygonId: PolygonId(field.fieldId),
          points: fieldBoundaries,
          strokeColor: Colors.orange,
          strokeWidth: 5,
          fillColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = Provider.of<List<FieldModel>>(context);

    _convertFieldsToPolygons(fields);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<MapSettingsProvider>(builder: (context, mapSettings, child) {
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    mapToolbarEnabled: false,
                    initialCameraPosition: mapSettings.cameraPosition,
                    mapType: mapSettings.mapType,
                    onCameraMove: (camera)=> mapSettings.setCameraPosition(camera),
                    polygons: Provider.of<NewFieldProvider>(context).geoPoints.isNotEmpty ? {..._polygons,  Provider.of<NewFieldProvider>(context).getPolygon()}: _polygons,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (point) {
                      if(!Provider.of<NewFieldProvider>(context, listen: false).addGeoPointWithLatLong(point)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Polygon cannot self intersect"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 25, right: 12),
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        FloatingActionButton(
                            backgroundColor: Colors.blueAccent[100],
                            child: const Icon(Icons.map_rounded),
                            onPressed: () {
                                mapSettings.toggleMapType();
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
