import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:frontend/providers/field_view_provider.dart';
import 'package:frontend/views/insights/field_insights.dart';
import 'package:frontend/views/insights/widgets/hidden_drawer.dart';
import 'package:provider/provider.dart';

/// This wrapper class will either display the insights for a field or the hidden drawer
class InsightsWrapper extends StatefulWidget {

  const InsightsWrapper({super.key});

  @override
  State<InsightsWrapper> createState() => _InsightsWrapperState();
}

class _InsightsWrapperState extends State<InsightsWrapper> {
  
  @override
  Widget build(BuildContext context) => ZoomDrawer(
    angle: -10,
    slideWidth: MediaQuery.of(context).size.width * 0.55,
    menuBackgroundColor: Colors.green.shade50,
    mainScreen: Stack(
          children: [
            Positioned.fill(
              child: FieldInsights(fieldId: Provider.of<FieldViewProvider>(context).field!.fieldId),
            ),
          ],
        ),
    menuScreen: const HiddenDrawer(),
    borderRadius: 30,
    showShadow: true,
  );

}