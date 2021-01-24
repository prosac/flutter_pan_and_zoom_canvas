import 'package:flutter/material.dart';

import 'test_data.dart';

class Item {
  const Item({
    this.offset,
    this.width,
    this.height,
    this.payload,
    this.presentation
  }) : assert(width != null),
        assert(height != null),
        assert(payload != null);

  final Offset offset;
  final double width;
  final double height;
  final TestData payload;
  final Widget presentation;
}
