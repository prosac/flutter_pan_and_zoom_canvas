import 'package:flutter/material.dart';

import 'test_data.dart';

class ItemData {
  const ItemData({this.offset, this.width, this.height, this.testData}) : assert(width != null, height != null);

  final Offset offset;
  final double width;
  final double height;
  final TestData testData;
}
