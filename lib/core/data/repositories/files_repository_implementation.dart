import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/local_filesystem_data_source.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/files_repository.dart';

class FilesRepositoryImplementation implements FilesRepository {
  // TODO: implement remote data source
  late LocalFilesystemDataSource localDataSource;

  FilesRepositoryImplementation({required this.localDataSource});

  @override
  Future<Either<Failure, List<FileSystemEntity>>> fsEntities() async {
    return Right(await localDataSource.fsEntities());
  }
}
