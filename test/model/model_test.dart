import 'dart:ui';

import 'package:flutter_pan_and_zoom/model/connection.dart';
import 'package:flutter_pan_and_zoom/model/model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:test/test.dart';

void main() {
  late GraphModel model;

  setUp(() async {
    model = GraphModel();
  });

  test('is a Model ;-)', () => expect(model, isA<GraphModel>()));

  group('.nodes()', () {
    test('is an Array of Nodes', () {
      expect(model.nodes(), isA<List>());
    });
  });

  group('.addNode', () {
    test('takes a Node and adds a it to the List of nodes inside the Model object', () {
      model.addNode(Node(Offset(1, 1)));

      expect(model.nodes(), everyElement(isA<Node>()));
      expect(model.nodes().length, 1);

      model.addNode(Node(Offset(1, 1)));

      expect(model.nodes(), everyElement(isA<Node>()));
      expect(model.nodes().length, 2);
    });
  });

  group('.connection()', () {
    test('is a List of Connections', () {
      expect(model.connections(), isA<List>());
    });
  });

  group('.addConnection()', () {
    test('takes two Nodes and adds a Connection between them to the list of connections inside the Model object', () {
      var node1 = Node(Offset(0, 0));
      var node2 = Node(Offset(100, 100));

      model.addConnection(node1, node2);

      expect(model.connections(), everyElement(isA<Connection>()));
    });
  });
}
