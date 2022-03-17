import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

class Node {
  Offset offset;
  var presentation;
  final TestData payload;
  int serialNumber = 0; // a simple and readable identifier for visual debugging

  Node({required this.offset, this.presentation, required this.payload});

  final GlobalKey key = GlobalKey();

  @override
  String toString() {
    return '${this.serialNumber}:\n${this.offset.dx}\n${this.offset.dy}';
  }

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
