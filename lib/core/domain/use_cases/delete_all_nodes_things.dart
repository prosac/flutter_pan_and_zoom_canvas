import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/void_use_case.dart';

// as it was before...
// void deleteAllTheThings(BuildContext context) {
//   context.read<ViewerState>().exitSpaceCommandMode();
//   context.read<Graph>().removeAll();
// }

class DeleteAllNodes implements VoidUseCase<void> {
  final Graph graph;

  DeleteAllNodes(this.graph);

  @override
  Future<Either<Failure, void>> call() async {
    return Future.value(Right(graph.removeAll()));
  }
}
