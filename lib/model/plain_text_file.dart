import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PlainTextFile {
  String fileName;

  PlainTextFile(this.fileName);

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> read() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> write(String contents) async {
    final file = await _localFile;

    return file.writeAsString(contents);
  }
}
