import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:frontend/views/insights/widgets/insights_selection.dart';

class InsightsButton extends StatelessWidget {

  const InsightsButton({super.key });

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
              backgroundColor: Colors.white,
              // TODO: Allow user to pick insight maps
              // TODO: Display name of insight map somewhere
              onPressed: () => ZoomDrawer.of(context)!.toggle(),
              child: Icon(
                  Icons.lightbulb_outline)
    );
  }

}