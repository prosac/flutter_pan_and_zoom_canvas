import 'package:flutter/material.dart';

import 'example_presentation.dart';
import 'model/node.dart';
import 'test_data.dart';
import 'item.dart';

Item buildItem(Offset offset, TestData payload) {
  return Item(
      offset: offset,
      payload: payload,
      presentation: ExamplePresentation(label: payload.text, offset: offset));
}

Node buildNode(Offset offset) {
  // TODO: there must be a more elegant way to build a 1 to 1 relation
  final presentation = ExamplePresentation(label: 'Foo', offset: offset);
  final node = Node(offset: offset, presentation: presentation);
  node.presentation.node = node;
  return node;
}
