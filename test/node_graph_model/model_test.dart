import 'dart:ui';
import 'package:flutter_pan_and_zoom/node_graph_model/connections_model.dart';
import 'package:flutter_pan_and_zoom/node_graph_model/model.dart';
import 'package:flutter_pan_and_zoom/node_graph_model/node.dart';
import 'package:test/test.dart';

void main() {
  Model model;

  setUp(() async {
    model = Model();
  });

  test('is a Model ;-)', () => expect(model, isA<Model>()));

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

  group('.connections()', () {
    test('is an Array of Connections', () {
      expect(model.connections(), isA<Connection>());
    });
  });
}