import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PlainTextFile {
  String fileName;
  String subDir = 'All-The-Things-Data';

  PlainTextFile(this.fileName) {}

  // TODO: try/catch somthing?
  Future<String> get _documentsDir async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  get storageDirPath => '$_documentsDir/$subDir';

  get storageDirPathExists => Directory(storageDirPath).exists;

  get absoluteStorageDirPath async => (await storageDir()).absolute;

  Future<Directory> storageDir() async {
    final dir = Directory(storageDirPath);

    if (await dir.existsSync()) {
      print('##### directory exists: ${await dir.absolute}');
      return await dir;
    } else {
      print('##### creating directory ${dir.absolute}');
      return await dir.create();
    }
  }

  Future<File> get _localFile async {
    final aaa = (await storageDir()).absolute;
    return File('${aaa}/$fileName');
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

    print('writing ${file.absolute}');
    return file.writeAsString(contents);
  }
}
