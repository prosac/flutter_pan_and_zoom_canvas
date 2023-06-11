import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';

class InitiateConnecting implements UseCase<Node, Params> {
  final Graph graph;
  final InteractionState interactionState;

  InitiateConnecting(this.graph, this.interactionState);

  @override
  Future<Either<Failure, Node>> call(Params params) async {
    interactionState.nodeToBeConnected = params.nodeToBeConnected;
    return Future.value(Right(params.nodeToBeConnected));
  }
}

class Params {
  final Node nodeToBeConnected;

  Params({required this.nodeToBeConnected});

  @override
  List<Object> get props => [nodeToBeConnected];
}
