import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

class Node {
  Offset offset = Offset(0, 0);
  // TODO: find out how to maka null safe one to one relation
  BasePresentation? presentation;
  final TestData payload;
  int serialNumber = 0; // a simple and readable identifier for visual debugging

  Node({required this.offset, this.presentation, required this.payload});

  get height => (presentation != null) ? presentation?.height : 0;

  // TODO: if we manage the potential of having no presentation here
  // maybe we should go for a null object by default for presentation
  get width => (presentation != null) ? presentation?.width : 0;

  @override
  String toString() {
    return '${this.serialNumber}:\n${this.offset.dx}\n${this.offset.dy}';
  }
}
