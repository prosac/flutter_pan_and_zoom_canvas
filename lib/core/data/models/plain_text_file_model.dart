// ignore_for_file: use_super_parameters

import 'dart:io';

import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';

class PlainTextFileModel extends PlainTextFile {
  PlainTextFileModel(String contents) : super(contents);

  factory PlainTextFileModel.fromFileSystemEntity(FileSystemEntity fileSystemEntity) {
    // TODO: name?
    // TODO: contents
    var contents = fileSystemEntity.toString();
    return PlainTextFileModel(contents);
  }

  // TODO: toFileSystemEntity()
}
