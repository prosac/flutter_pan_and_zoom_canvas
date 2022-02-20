import 'package:flutter/material.dart';

import 'example_presentation.dart';
import 'test_data.dart';
import 'item.dart';

Item buildItem(Offset offset, TestData payload) {
  return Item(
      offset: offset, payload: payload, presentation: ExamplePresentation(label: payload.text, color: payload.color));
}
