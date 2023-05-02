import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_pan_and_zoom/features/plain_text_files/domain/entities/plain_text_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../filesystem/domain/entities/fake_path_provider_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });
  group('PlainTextFile class', () {
    test('''is has an async static method .asyncNew() that returns a Future of
         an instance intitialized with a local storage path''', () async {
      expect(PlainTextFile.asyncNew('some-file.txt'),
          isA<Future<PlainTextFile>>());
    });

    test('awaiting resolved to an actual instance', () async {
      var plain_text_file = await PlainTextFile.asyncNew('some-file.txt');
      expect(plain_text_file, isA<PlainTextFile>());
    });

    group('PlainTextFile instance', () {
      late var plain_text_file;

      setUp(() async {
        plain_text_file = await PlainTextFile.asyncNew('some-file.txt',
            fs: MemoryFileSystem());
      });

      test(
          '''.file is a file with the full path including the os specific docs dir,
          the app dir and the file name''', () async {
        var appDocsDir = await getApplicationDocumentsDirectory();

        var expectedAbsolutePath =
            path.join(appDocsDir.path, 'All-The-Things-Data', 'some-file.txt');

        expect(plain_text_file.file, isA<File>());
        expect(plain_text_file.file.path, equals(expectedAbsolutePath));
      });

      test(
          '.write(String contents) uses the .writeAsString() method of the contained File plain_text_file to write contents to it',
          () async {
        final writtenFile = await plain_text_file.writeAsString('something');
        expect(writtenFile, isA<File>());
        final contents = await writtenFile.readAsString();
        expect(contents, equals('something'));
      });

      group('title', () {
        test('it reads the title from an org attribute', () async {
          final writtenFile =
              await plain_text_file.writeAsString('''#+title: The Title
                                                           More content
            ''');

          print(plain_text_file.title);
        });
      });
    });
  });
}
