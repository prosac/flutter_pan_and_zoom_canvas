import 'package:flutter/material.dart';

import 'example_presentation.dart';
import 'model/node.dart';
import 'test_data.dart';

Node buildNode(Offset offset, TestData payload) {
  // TODO: there must be a more elegant way to build a 1 to 1 relation
  final node = Node(offset: offset, payload: payload);
  final presentation = ExamplePresentation(label: 'Foo', offset: offset, node: node,);
  node.presentation = presentation;
  return node;
}
