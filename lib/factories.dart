import 'dart:ui';

import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/connection.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

void addThing(model, offset) {
  final newNode = Node(offset: offset, payload: TestData(text: 'Some other Payload'));

  // TODO: hot to best implement a bidirectional 1-1 relationsship
  newNode.presentation = ExamplePresentation(node: newNode, onAddPressed: () => { addThingFromExisting(model, newNode) });

  model.add(newNode);
}

void addThingFromExisting(GraphModel model, Node node) {
  // final Offset offset = node.offset.translate(node.width, node.height);
  final Offset offset = node.offset;
  final adaptedOffset = computeAdaptedOffset(node, offset);

  final newNode = Node(offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

  // TODO: hot to best implement a bidirectional 1-1 relationsship
  newNode.presentation = ExamplePresentation(node: newNode, onAddPressed: () => { addThingFromExisting(model, newNode) });

  model.add(newNode);
  model.connections = Connection(node, newNode);
}

Offset computeAdaptedOffset(Node node, Offset offset) {
  // TODO: yes, this must come from somewhere
  Size _backgroundSize = Size(4000, 4000);
  var addition = Offset((node.width + 20) / _backgroundSize.width, (node.height + 20) / _backgroundSize.height);

  return offset + addition;
}

  // void addFromExistingNode(Node existingNode, Node newNode) {
  //   newNode.serialNumber = nextSerialNumber();
  //   _nodes.add(newNode);
  //   _connections.add(Connection(existingNode, newNode));
  //   notifyListeners();
  // }
