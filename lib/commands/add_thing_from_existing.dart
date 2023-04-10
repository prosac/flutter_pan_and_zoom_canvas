import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/commands/build_node_actions.dart';
import 'package:flutter_pan_and_zoom/commands/compute_adapted_offset.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:provider/provider.dart';

void addThingFromExisting(Node node, BuildContext context) {
  final Offset offset = node.offset;
  final adaptedOffset = computeAdaptedOffset(node, offset, Size(node.presentation.width, node.presentation.height));
  final model = context.read<GraphModel>();

  final newNode = Node(offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

  newNode.actions = buildNodeActions(model, node, context);

  // TODO: how to best implement a bidirectional 1-1 relationsship
  newNode.presentation = ExamplePresentation(node: newNode);

  model.add(newNode);
  model.addEdge(node, newNode);
}
