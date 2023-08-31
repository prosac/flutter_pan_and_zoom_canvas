import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class InitiateConnecting implements UseCase<Node, InitiateConnectingParams> {
  final Graph graph;
  final InteractionState interactionState;

  InitiateConnecting(this.graph, this.interactionState);

  @override
  Future<Either<Failure, Node>> call(InitiateConnectingParams params) async {
    interactionState.nodeToBeConnected = params.nodeToBeConnected;
    return Future.value(Right(params.nodeToBeConnected));
  }
}

class InitiateConnectingParams {
  final Node nodeToBeConnected;

  InitiateConnectingParams({required this.nodeToBeConnected});

  @override
  List<Object> get props => [nodeToBeConnected];
}

initiateConnecting(nodeToBeConnected) {
  sl<InitiateConnecting>().call(InitiateConnectingParams(nodeToBeConnected: nodeToBeConnected));
}
