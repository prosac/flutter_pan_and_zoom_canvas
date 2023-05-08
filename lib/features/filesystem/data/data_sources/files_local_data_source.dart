import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';

abstract class FilesLocalDataSource {
  Future<Either<Failure, List<FileSystemEntity>>> entities();
}

class FilesLocalDataSourceImplementation implements FilesLocalDataSource {
  List<FileSystemEntity> _entities = [];

  @override
  Future<Either<Failure, List<FileSystemEntity>>> entities() async {
    return Future.value(Right(_entities));
  }
}
