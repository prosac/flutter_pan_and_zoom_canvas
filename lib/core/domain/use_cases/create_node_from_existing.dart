import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/presentation/compute_adapted_offset.dart';

// void addFromExisting(Node node, BuildContext context) {
//   final Offset offset = node.offset;
//   final adaptedOffset = computeAdaptedOffset(
//       node, offset, Size(node.presentation.width, node.presentation.height));
//   final model = context.read<Graph>();

//   final newNode = Node(
//       offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

//   newNode.actions = buildNodeActions(model, node, context);

//   // TODO: how to best implement a bidirectional 1-1 relationsship
//   newNode.presentation = ExamplePresentation(node: newNode);

//   model.add(newNode);
//   model.addEdge(node, newNode);
// }

class CreateNodeFromExisting implements UseCase<Node, Params> {
  final Graph graph;

  CreateNodeFromExisting(this.graph);

  @override
  Future<Either<Failure, Node>> call(Params params) async {
    final Offset offset = Offset(params.node.dx, params.node.dy);

    final adaptedOffset = computeAdaptedOffset(params.node, offset, Size(params.node.width, params.node.height));

    final dx = adaptedOffset.dx;
    final dy = adaptedOffset.dy;
    final node = Node(dx: dx, dy: dy);

    return Future.value(Right(node));
  }
}

class Params {
  final Node node;

  Params({required this.node});

  @override
  List<Object> get props => [node];
}
