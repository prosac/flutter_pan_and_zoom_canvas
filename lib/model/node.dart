import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

class Node {
  Offset offset = Offset(0, 0); // TODO: find out how to maka null safe one to one relation
  ExamplePresentation? presentation;
  final TestData payload;
  int serialNumber = 0; // a simple and readable identifier for visual debugging

  Node({required this.offset, this.presentation, required this.payload});

  final GlobalKey key = GlobalKey();

  @override
  String toString() {
    return '${this.serialNumber}:\n${this.offset.dx}\n${this.offset.dy}';
  }

  // TODO: if we manage the potential of having no presentation here
  // maybe we should go for a null object by default for presentation
  get width {
    return (presentation != null) ? presentation?.width : 0;
  }

  get height {
    return (presentation != null) ? presentation?.height : 0;
  }
}
