import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_pan_and_zoom/model/directory_contents.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';

void main() {
  group('DirectoryContents class', () {
    test('it is constructed with a String path', () async {
      expect(DirectoryContents('some_dir'), isA<DirectoryContents>());
    });

    group('DirectoryContents instance', () {
      late var instance;

      setUp(() async {
        instance = await DirectoryContents('some_dir', fs: MemoryFileSystem());
      });

      test('.list returns a Stream<FileSystemEntity>', () async {
        var appDocsDir = await getApplicationDocumentsDirectory();

        var expectedAbsolutePath =
            path.join(appDocsDir.path, 'All-The-Things-Data', 'some-file.txt');

        expect(instance.file, isA<File>());
        expect(instance.file.path, equals(expectedAbsolutePath));
      });

      test(
          '.write(String contents) uses the .writeAsString() method of the contained File instance to write contents to it',
          () async {
        final writtenFile = await instance.writeAsString('something');
        expect(writtenFile, isA<File>());
        final contents = await writtenFile.readAsString();
        expect(contents, equals('something'));
      });
    });
  });
}
