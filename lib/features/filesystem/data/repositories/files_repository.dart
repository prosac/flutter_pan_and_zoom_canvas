import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/features/filesystem/data/data_sources/files_local_data_source.dart';

class FilesRepositoryImplementation implements FilesRepository {
  // TODO: implement remote data source
  final FilesLocalDataSource localDataSource;

  FilesRepositoryImplementation({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<FileSystemEntity>>> entities() async {
    return await localDataSource.entities();
  }
}
