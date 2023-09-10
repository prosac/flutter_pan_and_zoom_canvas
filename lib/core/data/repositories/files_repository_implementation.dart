import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/local_filesystem_data_source.dart';
import 'package:flutter_pan_and_zoom/core/data/models/plain_text_file_model.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/files_repository.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class FilesRepositoryImplementation implements FilesRepository {
  @override
  Future<Either<Failure, List<PlainTextFileModel>>> allFiles() async {
    var localDataSource = sl<LocalFilesystemDataSource>();
    var fsEntities = await localDataSource.fsEntities();

    Right<Failure, List<PlainTextFileModel>> files =
        Right(fsEntities.map((FileSystemEntity e) => PlainTextFileModel(e.toString())).toList());
    return files;
  }
}
