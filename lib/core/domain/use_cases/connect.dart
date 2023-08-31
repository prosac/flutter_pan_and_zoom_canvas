import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class Connect implements UseCase<Edge, ConnectParams> {
  final Graph graph;
  final InteractionState interactionState;

  Connect(this.graph, this.interactionState);

  @override
  Future<Either<Failure, Edge>> call(ConnectParams params) async {
    // TODO: the node to be connected should also come in via params, the we would not need to handle that here
    if (interactionState.nodeToBeConnected == null) return Left(NoNodeToBeConnected());

    var edge = Edge(source: interactionState.nodeToBeConnected!, destination: params.otherNode);
    graph.addEdge(edge);

    return Future.value(Right(edge));
  }
}

class ConnectParams {
  final Node otherNode;

  ConnectParams({required this.otherNode});
}

class NoNodeToBeConnected extends Failure {}

class EdgeAlreadyExists extends Failure {}

connectNode(Node otherNode) async => sl<Connect>().call(ConnectParams(otherNode: otherNode));
