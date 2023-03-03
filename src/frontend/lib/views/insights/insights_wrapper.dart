import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:frontend/views/insights/field_insights.dart';
import 'package:frontend/views/insights/widgets/hidden_drawer.dart';

/// This wrapper class will either display the insights for a field or the hidden drawer
class InsightsWrapper extends StatefulWidget {

  final String fieldId;

  const InsightsWrapper({super.key, required this.fieldId });

  @override
  State<InsightsWrapper> createState() => _InsightsWrapperState();
}

class _InsightsWrapperState extends State<InsightsWrapper> {

  // TODO: Keep track of current selected insights
  
  @override
  Widget build(BuildContext context) => ZoomDrawer(
    angle: -10,
    slideWidth: MediaQuery.of(context).size.width * 0.65,
    menuBackgroundColor: Colors.blueAccent,
    mainScreen: Stack(
          children: [
            Positioned.fill(
              child: FieldInsights(fieldId: widget.fieldId),
            ),
          ],
        ),
    menuScreen: const HiddenDrawer()
  );

}