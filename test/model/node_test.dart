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
      return {expect(node, isA<Node>())};
    });

    test('is a Node ;-)', () {
      return {expect(node, isA<Node>())};
    });
  });

  group('A Node with presentation', () {
    setUp(() async {
      node = Node(offset: Offset.zero, payload: TestData());
    });

    test('is a Node ;-)', () {
      return {expect(node, isA<Node>())};
    });
  });
}
