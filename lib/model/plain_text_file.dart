import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PlainTextFile {
  PlainTextFile._constructor(this.file);

  final File file;
  static final String subDirName = 'All-The-Things-Data';

  static Future<PlainTextFile> create(String fileName,
      {FileSystem fs = const LocalFileSystem()}) async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final absoluteStoragePath = path.join(appDocsDir.path, subDirName);
    final absoluteStorageDir =
        await fs.directory(absoluteStoragePath).create(recursive: true);
    final absoluteFilePath = path.join(absoluteStorageDir.path, fileName);

    return PlainTextFile._constructor(fs.file(absoluteFilePath));
  }

  // Future<String> read() async {
  //   try {
  //     final file = await _localFile;
  //     final contents = await file.readAsString();

  //     return contents;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  Future<File> writeAsString(String contents) async {
    return file.writeAsString(contents);
  }

  Future<String> readAsString(String contents) async {
    return file.readAsString().then((String contents) {
      return contents;
    });
  }
}
