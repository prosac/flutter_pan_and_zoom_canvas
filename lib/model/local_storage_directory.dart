import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathLib;

class LocalStorageDirectory {
  static final String subDirName = 'All-The-Things-Data';

  // TODO: extract the local storage dir stuff and use it in PlainTextFile and here
  Future<List<FileSystemEntity>> files({FileSystem fs = const LocalFileSystem()}) async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final absoluteStoragePath = pathLib.join(appDocsDir.path, subDirName);
    final absoluteStorageDir = await fs.directory(absoluteStoragePath);
    return _directoryContents(absoluteStorageDir);
  }

  Future<List<FileSystemEntity>> _directoryContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file), onDone: () => completer.complete(files), onError: (error) => print(error));
    return completer.future;
  }
}
