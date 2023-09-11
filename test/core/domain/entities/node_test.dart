import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:test/test.dart';

void main() {
  late Node node;

  group('A Node', () {
    setUp(() async {
      node = Node();
    });

    test('toString() includes the serial nr and offset', () {
      expect(node.toString(), matches('id: \d+\ndx: \d+\.\d+\ndy: \d+\.\d+\n\d+'));
    });
  });

  group('factories', () {
    group('random', () {
      setUp(() async {
        node = Node.random();
      });
      test('creates a random node', () {
        expect(node, isA<Node>());
      });
      test('the nodes offset is in bearable bounds', () {
        expect(node.dx, lessThanOrEqualTo(1000));
        expect(node.dy, lessThanOrEqualTo(1000));
      });
    });
  });
}
