import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';

class CreateNode implements UseCase<Node, CreateNodeParams> {
  final Graph graph;
  final ViewerState viewerState;

  CreateNode(this.graph, this.viewerState);

  @override
  Future<Either<Failure, Node>> call(CreateNodeParams params) async {
    final node = Node.random();

    graph.addNode(node);

    viewerState.exitSpaceCommandMode();
    return Future.value(Right(node));
  }
}

class CreateNodeParams extends Equatable {
  final double dx;
  final double dy;

  CreateNodeParams({required this.dx, required this.dy});

  @override
  List<Object> get props => [dx, dy];
}
