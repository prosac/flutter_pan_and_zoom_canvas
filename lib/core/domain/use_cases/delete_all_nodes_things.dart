import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/nodes_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/void_use_case.dart';

// as it was before...
// void deleteAllTheThings(BuildContext context) {
//   context.read<ViewerState>().exitSpaceCommandMode();
//   context.read<GraphModel>().removeAll();
// }

class DeleteAllNodes implements VoidUseCase<void> {
  final NodesRepository repository;

  DeleteAllNodes(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.deleteAllTheThings();
  }
}
