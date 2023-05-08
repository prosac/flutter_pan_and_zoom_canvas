import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';

abstract class FilesRepository {
  Future<Either<Failure, List<FileSystemEntity>>> entities();
}
