import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/local_filesystem_data_source.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/files_repository.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class FilesRepositoryImplementation implements FilesRepository {
  @override
  Future<Either<Failure, List<FileSystemEntity>>> fsEntities() async {
    var localDataSource = sl<LocalFilesystemDataSource>();
    return Right(await localDataSource.fsEntities());
  }
}
