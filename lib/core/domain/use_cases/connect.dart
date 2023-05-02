import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph_model.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/graph_components_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';

// as it was before
// void connect({required Node otherNode, required BuildContext context}) {
//   final model = context.read<GraphModel>();
//   model.addEdgeTo(otherNode);
// }

class Connect implements UseCase<Node, Params> {
  final GraphComponentsRepository graphComponentsRepo;
  final InteractionState interactionState;

  Connect(this.graphComponentsRepo, this.interactionState);

  @override
  Future<Either<Failure, Edge>> call(Params params) async {
    if (interactionState.nodeToBeConnected == null)
      return Left(NoNodeToBeConnected());

    final edge = Edge(
        node: interactionState.nodeToBeConnected!, otherNode: params.otherNode);

    final List<Edge> edges = await graphComponentsRepo.edges();

    if (edges.contains(edge)) return Left(EdgeAlreadyExists());

    graphComponentsRepo.createEdge();

    interactionState.nodeToBeConnected = null;
    return Right(edge);
  }
}

class Params {
  final Node otherNode;

  Params({required this.otherNode});
}

class NoNodeToBeConnected extends Failure {}

class EdgeAlreadyExists extends Failure {}
