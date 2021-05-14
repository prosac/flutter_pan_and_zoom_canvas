import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/node_graph_model/node.dart';
import 'package:test/test.dart';

void main() {
  Node node;

  setUp(() async {
    node = Node(Offset.zero);
  });

  test('is a Node ;-)', () => expect(node, isA<Node>()));
}
