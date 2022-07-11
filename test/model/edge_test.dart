import 'dart:ui';

import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:test/test.dart';

void main() {
  late Edge edge;
  late Node node1;
  late Node node2;

  group('An Edge', () {
    setUp(() async {
      node1 = Node(offset: Offset.zero, payload: TestData());
      node2 = Node(offset: Offset.zero, payload: TestData());
      edge = Edge(node1, node2);
    });

    test('is an Edge ;-)', () {
      return {expect(edge, isA<Edge>())};
    });

    test('knows two nodes', () {
      expect(edge.node1, node1);
      expect(edge.node2, node2);
    });

    test('isConnectedTo(node1)', () {
      expect(edge.isConnectedTo(node1), true);
    });

    test('isConnectedTo(node2)', () {
      expect(edge.isConnectedTo(node2), true);
    });
  });
}
