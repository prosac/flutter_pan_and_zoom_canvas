import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/build_node_actions.dart';
import 'package:flutter_pan_and_zoom/core/presentation/compute_adapted_offset.dart';
import 'package:flutter_pan_and_zoom/core/presentation/example_presentation.dart';

void addFromExisting(Node node, BuildContext context) {
  final Offset offset = node.offset;
  final adaptedOffset = computeAdaptedOffset(
      node, offset, Size(node.presentation.width, node.presentation.height));
  final model = context.read<GraphModel>();

  final newNode = Node(
      offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

  newNode.actions = buildNodeActions(model, node, context);

  // TODO: how to best implement a bidirectional 1-1 relationsship
  newNode.presentation = ExamplePresentation(node: newNode);

  model.add(newNode);
  model.addEdge(node, newNode);
}
