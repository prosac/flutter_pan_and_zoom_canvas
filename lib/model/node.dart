import 'package:flutter/widgets.dart';

class Node {
  Offset offset;
  final presentation;

  Node({required this.offset, required this.presentation});

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
