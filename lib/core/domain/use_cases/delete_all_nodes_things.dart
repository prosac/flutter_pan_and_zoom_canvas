import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/void_use_case.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class DeleteAllNodes implements VoidUseCase<void> {
  @override
  Future<Either<Failure, void>> call() async {
    return Future.value(Right(sl<Graph>().removeAll()));
  }
}

deleteAllNodes() => sl<DeleteAllNodes>().call();
