import 'dart:math';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/presentation/compute_adapted_offset.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class CreateNodeFromExisting implements UseCase<Node, CreateNodeFromExistingParams> {
  @override
  Future<Either<Failure, Node>> call(CreateNodeFromExistingParams params) async {
    final Offset offset = Offset(params.node.dx, params.node.dy);
    final adaptedOffset = computeAdaptedOffset(params.node, offset, Size(params.node.width, params.node.height));
    final dx = adaptedOffset.dx + 20;
    final dy = adaptedOffset.dy + 20;
    final graph = sl<Graph>();
    final nextId = graph.nodes.map((e) => e.id).toList().reduce(max) + 1;

    final node = Node(dx: dx, dy: dy, id: nextId);

    graph.addNode(node);
    graph.addEdge(Edge(source: params.node, destination: node));

    return Future.value(Right(node));
  }
}

class CreateNodeFromExistingParams {
  final Node node;

  CreateNodeFromExistingParams({required this.node});
}

createNodeFromExisting(node) => sl<CreateNodeFromExisting>().call(CreateNodeFromExistingParams(node: node));
