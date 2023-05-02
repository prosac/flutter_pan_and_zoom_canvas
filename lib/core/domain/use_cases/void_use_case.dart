import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';

abstract class VoidUseCase<Params> {
  Future<Either<Failure, void>> call();
}
