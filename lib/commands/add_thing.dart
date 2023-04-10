// TODO: maybe this should be called something like GraphicalNodeRepresentation and thus graphicalNodeRepresentations
import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/commands/build_node_actions.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:provider/provider.dart';

void addThing(offset, BuildContext context) {
  final node = Node(offset: offset, payload: TestData(text: 'Some other Payload'));
  final model = context.read<GraphModel>();

  node.actions = buildNodeActions(model, node, context);

  // TODO: hot to best implement a bidirectional 1-1 relationsship
  node.presentation = ExamplePresentation(node: node);

  model.add(node);
  context.read<ViewerState>().exitSpaceCommandMode();
}
