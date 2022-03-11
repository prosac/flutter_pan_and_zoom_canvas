import 'package:flutter/widgets.dart';
import 'test_data.dart';

// TODO remove in favor of Node?
class Item {
  Offset offset;

  Item({required this.offset, required this.payload, required this.presentation});

  final TestData payload;
  final presentation;

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
