import 'package:flutter/material.dart';

// this is not used yet. just a sketch on how to draw a simple line.
// eventually this will evolve into a class for visual connections between things
class ConnectionPainter extends CustomPainter {
  // https://medium.com/flutter-community/paths-in-flutter-a-visual-guide-6c906464dcd0
  Offset start;
  Offset p1;
  Offset p2;
  Offset end;

  ConnectionPainter({
    this.start,
    this.end
  });

  @override
  void paint(Canvas canvas, Size size) async {
    final linePaint = Paint()
      ..color = Colors.red[800]
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    p1 = Offset(start.dx + 100, start.dy);
    p2 = Offset(end.dx + 100, end.dy);

    final path = new Path()
      ..addOval(Rect.fromCenter(center: Offset(0, 0), width: 20, height: 20))
      ..moveTo(start.dx, start.dy)
      ..cubicTo(p1.dx, p1.dy, p2.dy, p2.dy, end.dx, end.dy)
      ..moveTo(end.dx, end.dy)
      ..addOval(Rect.fromCenter(center: Offset(100, 100), width: 20, height: 20));

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
