import 'package:flutter/material.dart';

// this is not used yet. just a sketch on how to draw a simple line.
// eventually this will evolve into a class for visual connections between things
class ConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) async {
    final linePaint = Paint()
      ..color = Colors.red[800]
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = new Path()
      ..moveTo(200, 100)
      ..lineTo(100, 300)
      ..close();

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
