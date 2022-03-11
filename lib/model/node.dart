import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

class Node {
  Offset offset;
  final presentation;
  final TestData payload;

  Node({required this.offset, required this.presentation, required this.payload});

  // TODO what was this for?
  // Widget _widget;
  // get key => _widget.key;

  @override
  String toString() {
    return 'Node ${this.hashCode}}';
  }

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
