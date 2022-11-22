import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryContents {
  DirectoryContents._constructor(this.file);

  final File file;
  static final String subDirName = 'All-The-Things-Data';

  get path => file.path;

  static Future<DirectoryContents> asyncNew(String fileName,
      {FileSystem fs = const LocalFileSystem()}) async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final absoluteStoragePath = pathLib.join(appDocsDir.path, subDirName);
    final absoluteStorageDir =
        await fs.directory(absoluteStoragePath).create(recursive: true);
    final absoluteFilePath = pathLib.join(absoluteStorageDir.path, fileName);

    return DirectoryContents._constructor(fs.file(absoluteFilePath));
  }

  Stream<FileSystemEntity> list() {
    return dir.list();
  }
}
