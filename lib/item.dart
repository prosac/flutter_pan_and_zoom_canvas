import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';

import 'test_data.dart';

class Item {
  const Item({
    this.offset,
    this.payload,
    this.presentation
  }) : assert(payload != null);

  final Offset offset;
  final TestData payload;
  final ExamplePresentation presentation;

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
