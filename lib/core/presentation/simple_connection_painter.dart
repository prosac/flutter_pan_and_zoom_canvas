import 'package:flutter/material.dart';

/// A [CustomPainter] for drawing connections between points represented by [Offset]s
class SimpleConnectionPainter extends CustomPainter {
  // https://medium.com/flutter-community/paths-in-flutter-a-visual-guide-6c906464dcd0
  Offset? start;
  late Offset p1;
  late Offset p2;
  Offset? end;

  SimpleConnectionPainter({this.start, this.end});

  @override
  void paint(Canvas canvas, Size size) async {
    final linePaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 14.0
      ..style = PaintingStyle.stroke;

    p1 = Offset(start!.dx, start!.dy);
    p2 = Offset(end!.dx, end!.dy);

    final line = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);

    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
