import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// DataSource notes
// deals with all details of storing, retrieving, caching
// It does NOT use Either
// It DOES return model instances
// Models extend entities
abstract class LocalFilesystemDataSource {
  Future<List<FileSystemEntity>> fsEntities();

  Future<FileSystemEntity> createFile(String fileName, String contents,
      {FileSystem fs = const LocalFileSystem()}); // TODO: what to pass?

  Future<String> reasAsString(File file);

  void delete(FileSystemEntity fsEntity);
}

class LocalFilesystemDataSourceImplementation implements LocalFilesystemDataSource {
  static final String subDirName = 'All-The-Things-Data';
  List<FileSystemEntity> _fsEntities = [];

  @override
  Future<List<FileSystemEntity>> fsEntities({FileSystem fs = const LocalFileSystem()}) async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final absoluteStoragePath = join(appDocsDir.path, subDirName);
    final absoluteStorageDir = await fs.directory(absoluteStoragePath);
    return _directoryContents(absoluteStorageDir);
  }

  @override
  Future<FileSystemEntity> createFile(String fileName, String contents,
      {FileSystem fs = const LocalFileSystem()}) async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final absoluteStoragePath = join(appDocsDir.path, subDirName);
    final absoluteStorageDir = await fs.directory(absoluteStoragePath).create(recursive: true);
    final absoluteFilePath = join(absoluteStorageDir.path, fileName);
    final file = await fs.file(absoluteFilePath);

    file.writeAsString(contents);

    return file;
  }

  Future<String> reasAsString(File file) {
    return file.readAsString().then((String contents) {
      return contents;
    });
  }

  @override
  void delete(FileSystemEntity fsEntity) {
    // TODO: implement fsEntity deletion
  }

  Future<List<FileSystemEntity>> _directoryContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file), onDone: () => completer.complete(files), onError: (error) => print(error));
    return completer.future;
  }
}
