import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/providers/new_field_provider.dart';
import 'package:provider/provider.dart';

class BottomBarAddField extends StatelessWidget {
  final Function()? onPressed;
  const BottomBarAddField({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()=>Provider.of<NewFieldProvider>(context, listen: false).removeLastGeoPoint(),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: const Icon(
                Icons.refresh,
                color: Colors.black,
                size: 50,
              ),
            ),
          ), // Button
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const SizedBox(
              width: 100,
              height: 50,
              child: Center(
                child: Text('Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}