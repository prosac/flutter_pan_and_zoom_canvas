import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/void_use_case.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';

// as it was before...
// void deleteAllTheThings(BuildContext context) {
//   context.read<ViewerState>().exitSpaceCommandMode();
//   context.read<Graph>().removeAll();
// }

class ResetViewport implements VoidUseCase<void> {
  final ViewerState viewerState;

  ResetViewport(this.viewerState);

  @override
  Future<Either<Failure, void>> call() {
    return Future.value(Right(viewerState.resetView()));
  }
}
