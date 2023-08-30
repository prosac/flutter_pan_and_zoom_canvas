import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/void_use_case.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class ResetViewport implements VoidUseCase<void> {
  @override
  Future<Either<Failure, void>> call() {
    return Future.value(Right(sl<ViewerState>().resetView()));
  }
}
