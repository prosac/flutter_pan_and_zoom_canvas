import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/test_data.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/nodes_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';

// as it used to be...
// void addThing(offset, BuildContext context) {
//   final node =
//       Node(offset: offset, payload: TestData(text: 'Some other Payload'));
//   final model = context.read<GraphModel>();

//   node.actions = buildNodeActions(model, node, context);

//   // TODO: hot to best implement a bidirectional 1-1 relationsship
//   node.presentation = ExamplePresentation(node: node);

//   model.add(node);
//   context.read<ViewerState>().exitSpaceCommandMode();
// }

class CreateNode implements UseCase<Node, Params> {
  final NodesRepository repository;

  CreateNode(this.repository);

  @override
  Future<Either<Failure, Node>> call(Params params) async {
    final node = Node(
        offset: params.offset, payload: TestData(text: 'Some other Payload'));
    return await repository.createNode(params.data);
  }
}

class Params {
  final Node data;
  final Offset offset;

  Params({required this.data, required this.offset});

  @override
  List<Object> get props => [data];
}
