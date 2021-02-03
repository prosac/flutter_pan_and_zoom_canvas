import 'package:flutter/material.dart';

import 'test_data.dart';

class Item {
  Item({
    this.offset,
    this.payload,
    this.presentation
  }) : assert(payload != null);

  Offset offset;
  final TestData payload;
  final presentation;

  get width {
    return presentation.width;
  }

  get height {
    return presentation.height;
  }
}
