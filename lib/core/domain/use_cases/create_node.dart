import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';

// as it used to be...
// void addThing(offset, BuildContext context) {
//   final node =
//       Node(offset: offset, payload: TestData(text: 'Some other Payload'));
//   final model = context.read<Graph>();

//   node.actions = buildNodeActions(model, node, context);

//   // TODO: hot to best implement a bidirectional 1-1 relationsship
//   node.presentation = ExamplePresentation(node: node);

//   model.add(node);
//   context.read<ViewerState>().exitSpaceCommandMode();
// }

class CreateNode implements UseCase<Node, Params> {
  final Graph graph;
  final ViewerState viewerState;

  CreateNode(this.graph, this.viewerState);

  @override
  Future<Either<Failure, Node>> call(Params params) async {
    // final node = Node(dx: params.dx, dy: params.dy);
    final node = Node.random();
    graph.addNode(node);
    viewerState.exitSpaceCommandMode();
    return Future.value(Right(node));
  }
}

class Params extends Equatable {
  final double dx;
  final double dy;

  Params({required this.dx, required this.dy});

  @override
  List<Object> get props => [dx, dy];
}