import 'dart:io';

import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// TODO: mock actual file access
// class MockFile extends Mock implements File {
//   @override
//   Future<File> writeAsBytes(List<int> bytes,
//       {FileMode mode = FileMode.write, bool flush = false}) {
//     // TODO: implement writeAsBytes
//     throw UnimplementedError();
//   }
// }

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
        instance = await PlainTextFile.create('some-file.txt');
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
        final writtenFile = instance.writeAsString('something');
        expect(writtenFile, isA<Future<File>>());
        final contents = await writtenFile.readAsString();
        expect(contents, equals('something'));
      });
    });
  });
}
