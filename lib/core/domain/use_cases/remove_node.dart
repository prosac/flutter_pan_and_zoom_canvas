import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class RemoveNode implements UseCase<Node, RemoveNodeParams> {
  final Graph graph;
  RemoveNode(this.graph);

  @override
  Future<Either<Failure, Node>> call(RemoveNodeParams params) async {
    graph.removeNode(params.node);

    return Future.value(Right(params.node));
  }
}

class RemoveNodeParams extends Equatable {
  final Node node;

  RemoveNodeParams(this.node);

  @override
  List<Object> get props => [node];
}

Future<void> removeNode(node) async => sl<RemoveNode>()(RemoveNodeParams(node));
