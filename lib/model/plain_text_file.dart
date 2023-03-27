import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:org_parser/org_parser.dart' as org;

class PlainTextFile {
  PlainTextFile._constructor(this.file);

  final File file;
  static final String subDirName = 'All-The-Things-Data';

  get path => file.path;

  String title() {
    final doc = org.OrgDocument.parse(file.readAsStringSync());
    String value = '';

    doc.children[0].visit<org.OrgMeta>((thing) {
      if (thing.keyword.contains('title')) {
        value = thing.trailing.trim();
        return false;
      } else {
        value = thing.trailing.trim();
        return true;
      }
    });

    return value;
  }

  static Future<PlainTextFile> asyncNew(String fileName, {FileSystem fs = const LocalFileSystem()}) async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final absoluteStoragePath = pathLib.join(appDocsDir.path, subDirName);
    final absoluteStorageDir = await fs.directory(absoluteStoragePath).create(recursive: true);
    final absoluteFilePath = pathLib.join(absoluteStorageDir.path, fileName);

    return PlainTextFile._constructor(fs.file(absoluteFilePath));
  }

  static Future<PlainTextFile> asyncFromFile(File file, {FileSystem fs = const LocalFileSystem()}) async {
    return PlainTextFile._constructor(file);
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
