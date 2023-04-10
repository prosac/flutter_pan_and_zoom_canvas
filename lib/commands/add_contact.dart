import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/commands/add_thing_from_existing.dart';
import 'package:flutter_pan_and_zoom/contact_presentation.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:provider/provider.dart';

void addContact(GraphModel model, Offset offset, BuildContext context) {
  final newNode = Node(offset: offset, payload: TestData(text: 'Some human'));

  newNode.presentation =
      ConatactPresentation(node: newNode, onAddPressed: () => addThingFromExisting(newNode, context));

  model.add(newNode);
  context.read<ViewerState>().exitSpaceCommandMode();
}
