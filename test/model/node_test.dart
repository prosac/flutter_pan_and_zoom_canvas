import 'dart:ui';

import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:test/test.dart';

void main() {
  late Node node;

  group('A Node', () {
    setUp(() async {
      node = Node(offset: Offset.zero, payload: TestData());
    });

    test('is a Node ;-)', () {
      expect(node, isA<Node>());
    });

    test('is a Node ;-)', () {
      expect(node, isA<Node>());
    });
  });

  group('A Node with presentation', () {
    setUp(() async {
      node = Node(offset: Offset.zero, payload: TestData());
    });

    test('is a Node ;-)', () {
      expect(node, isA<Node>());
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
        expect(node.offset.dx, lessThanOrEqualTo(1000));
        expect(node.offset.dy, lessThanOrEqualTo(1000));
      });
    });
  });
}
