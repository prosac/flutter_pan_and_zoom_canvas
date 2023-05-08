import 'package:dartz/dartz.dart';
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

class Connect implements UseCase<Edge, Params> {
  final GraphComponentsRepository graphComponentsRepo;
  final InteractionState interactionState;

  Connect(this.graphComponentsRepo, this.interactionState);

  @override
  Future<Either<Failure, Edge>> call(Params params) async {
    if (interactionState.nodeToBeConnected == null) return Left(NoNodeToBeConnected());

    final edgesOrFailure = await graphComponentsRepo.edges();

    return edgesOrFailure.fold((failure) {
      return Left(failure);
    }, (edges) async {
      // TODO: how to get rid of the !?
      var edge =
          await graphComponentsRepo.createEdge(node: interactionState.nodeToBeConnected!, otherNode: params.otherNode);
      interactionState.nodeToBeConnected = null;
      return edge;
    });
  }
}

class Params {
  final Node otherNode;

  Params({required this.otherNode});
}

class NoNodeToBeConnected extends Failure {}

class EdgeAlreadyExists extends Failure {}
