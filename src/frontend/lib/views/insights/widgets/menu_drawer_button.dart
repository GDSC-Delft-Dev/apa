import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:frontend/views/insights/widgets/hidden_drawer.dart';

class MenuDrawerButton extends StatelessWidget {

  const MenuDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => ZoomDrawer.of(context)!.toggle(),
              child: Icon(Icons.menu)
    );
  }

}