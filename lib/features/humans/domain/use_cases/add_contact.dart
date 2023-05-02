import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/data/test_data.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph_model.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/features/humans/presentation/contact_presentation.dart';
import 'package:flutter_pan_and_zoom/features/nodes/domain/use_cases/add_node_from_existing.dart';

void addContact(GraphModel model, Offset offset, BuildContext context) {
  final newNode = Node(offset: offset, payload: TestData(text: 'Some human'));

  newNode.presentation = ConatactPresentation(
      node: newNode,
      onAddPressed: () => addThingFromExisting(newNode, context));

  model.add(newNode);
  context.read<ViewerState>().exitSpaceCommandMode();
}
