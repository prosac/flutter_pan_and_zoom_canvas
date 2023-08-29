import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';

// as it was before
// void connect({required Node otherNode, required BuildContext context}) {
//   final model = context.read<Graph>();
//   model.addEdgeTo(otherNode);
// }

class Connect implements UseCase<Edge, Params> {
  final Graph graph;
  final InteractionState interactionState;

  Connect(this.graph, this.interactionState);

  @override
  Future<Either<Failure, Edge>> call(Params params) async {
    if (interactionState.nodeToBeConnected == null) return Left(NoNodeToBeConnected());

    var edge = Edge(source: interactionState.nodeToBeConnected!, destination: params.otherNode);
    graph.addEdge(edge);

    return Future.value(Right(edge));
  }
}

class Params {
  final Node otherNode;

  Params({required this.otherNode});
}

class NoNodeToBeConnected extends Failure {}

class EdgeAlreadyExists extends Failure {}
