import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';

import 'test_data.dart';

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
