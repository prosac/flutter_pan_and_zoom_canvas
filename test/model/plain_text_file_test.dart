import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';

void main() {
  group('PlainTextFile class', () {
    test('''is has an async static method .create() that returns a Future of
         an instance intitialized with a local storage path''', () async {
      expect(
          PlainTextFile.create('some-file.txt'), isA<Future<PlainTextFile>>());
    });

    test('awaiting resolved to an actual instance', () async {
      var instance = await PlainTextFile.create('some-file.txt');
      expect(instance, isA<PlainTextFile>());
    });

    group('PlainTextFile instance', () {
      late var instance;

      setUp(() async {
        instance =
            await PlainTextFile.create('some-file.txt', fs: MemoryFileSystem());
      });

      test(
          '''.file is a file with the full path including the os specific docs dir,
          the app dir and the file name''', () async {
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
