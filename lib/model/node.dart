import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

class Node {
  Offset offset;
  var presentation;
  final TestData payload;

  Node({required this.offset, this.presentation, required this.payload});

  // TODO what was this for?
  // Widget _widget;
  // get key => _widget.key;

  final GlobalKey key = GlobalKey();

  @override
  String toString() {
    return '${this.offset}';
  }

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
