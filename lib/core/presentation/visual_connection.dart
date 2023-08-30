import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_connection_painter.dart';

class VisualConnection extends StatelessWidget {
  final Edge edge;

  VisualConnection(Edge this.edge);

  @override
  Widget build(BuildContext context) {
    Size size1 = Size(edge.source.width, edge.destination.height);
    Size size2 = Size(edge.source.width, edge.destination.height);

    Offset nodeOffset1 = Offset(edge.source.dx, edge.source.dy);
    Offset nodeOffset2 = Offset(edge.destination.dx, edge.destination.dy);

    Offset offset1AdaptedToBackground = nodeOffset1;
    Offset offset2AdaptedToBackground = nodeOffset2;

    Offset offset1 =
        Offset(offset1AdaptedToBackground.dx + size1.width / 2, offset1AdaptedToBackground.dy + size1.height / 2);
    Offset offset2 =
        Offset(offset2AdaptedToBackground.dx + size2.width / 2, offset2AdaptedToBackground.dy + size2.height / 2);

    return CustomPaint(painter: SimpleConnectionPainter(start: offset1, end: offset2));
  }
}
