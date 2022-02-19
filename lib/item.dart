import 'package:flutter_pan_and_zoom/example_presentation.dart';

import 'test_data.dart';

class Item {
  var offset;

  Item({this.offset, required this.payload, required this.presentation});

  final TestData payload;
  final presentation;

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
