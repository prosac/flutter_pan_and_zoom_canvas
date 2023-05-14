import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:test/test.dart';

void main() {
  late Node node;

  group('A Node', () {
    setUp(() async {
      node = Node();
    });

    test('toString() includes the serial nr and offset', () {
      expect(node.toString(), '0:\n0.0\n0.0');
    });

    // TODO: really required?
    // test('Knows its connected Edges', () {
    //   var destination = Node();
    //   var edge = Edge(source: node, destination: destination);

    //   node.addEdge(edge);

    //   expect(node.edges, contains(edge));
    // });
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
