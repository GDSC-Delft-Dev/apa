// This widget will display the field polygon on the field tile
import 'package:flutter/material.dart';
import 'package:frontend/models/field_model.dart';

class CanvasField extends StatefulWidget {
  const CanvasField({super.key, required this.field});
  final FieldModel field;

  @override
  State<CanvasField> createState() => _CanvasFieldState();
}

class _CanvasFieldState extends State<CanvasField> {

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        size: const Size(50, 50),
        painter: FieldPainter(field: widget.field),
      ),
    );
  }
}

// Custom painter to draw the field polygon
class FieldPainter extends CustomPainter {
  final FieldModel field;

  FieldPainter({required this.field});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    var polygon = field.boundaries;

    // Find min and max values
    var minX = polygon[0].longitude;
    var maxX = polygon[0].longitude;
    var minY = polygon[0].latitude;
    var maxY = polygon[0].latitude;
    
    for (var i = 1; i < polygon.length; i++) {
      if (polygon[i].longitude < minX) {
        minX = polygon[i].longitude;
      }
      if (polygon[i].longitude > maxX) {
        maxX = polygon[i].longitude;
      }
      if (polygon[i].latitude < minY) {
        minY = polygon[i].latitude;
      }
      if (polygon[i].latitude > maxY) {
        maxY = polygon[i].latitude;
      }
    }

    // Draw polygon
    path.moveTo(
        (polygon[0].longitude - minX) * size.width / (maxX - minX),
        50 - (polygon[0].latitude - minY) * size.height / (maxY - minY));
    for (var i = 1; i < polygon.length; i++) {
      path.lineTo(
          (polygon[i].longitude - minX) * size.width / (maxX - minX),
          50 - (polygon[i].latitude - minY) * size.height / (maxY - minY));
    }

    
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
