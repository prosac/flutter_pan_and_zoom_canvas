import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Graph graph;

  setUp(() async {
    graph = Graph();
  });

  group('nodes', () {
    test('initially is an empty list', () {
      expect(graph.nodes, isA<List>());
    });
  });

  group('edges', () {
    test('initially is an empty list', () {
      expect(graph.edges, isA<List>());
    });
  });

  group('addNode(Node node)', () {
    test('adds node', () {
      graph.addNode(Node(id: 1));
      expect(graph.nodes[0].id, 1);
      graph.addNode(Node(id: 2));
      expect(graph.nodes[1].id, 2);
    });
  });

  group('addEdge(Node source, Node destination)', () {
    test('adds an Edge from node to node', () {
      var edge = Edge(source: Node(), destination: Node());
      graph.addEdge(edge);
      expect(graph.edges[0], equals(edge));
    });
  });

  group('removing nodes and edges', () {
    late Node node1;
    late Node node2;
    late Node node3;
    late Edge edge1;
    late Edge edge2;

    setUp(() async {
      node1 = Node(id: 1);
      node2 = Node(id: 2);
      node3 = Node(id: 3);
      graph.addNode(node1);
      graph.addNode(node2);
      graph.addNode(node3);

      edge1 = Edge(source: node1, destination: node2);
      edge2 = Edge(source: node2, destination: node3);

      graph.addEdge(edge1);
      graph.addEdge(edge2);
    });
    group('removeNode(Node node)', () {
      test('removes node and connected edges', () {
        expect(graph.nodes, contains(node3));
        graph.removeNode(node3);
        expect(graph.nodes, isNot(contains(node3)));
        expect(graph.edges, isNot(contains(edge2)));
      });
    });

    group('removeEdge(Edge edge)', () {
      test('removes edge', () {
        expect(graph.nodes, contains(node3));
        expect(graph.edges.length, 2);
        graph.removeEdge(edge1);
        expect(graph.edges, isNot(contains(edge1)));
        expect(graph.edges, contains(edge2));
      });
    });

    group('removeAll()', () {
      test('removes all nodes', () {
        expect(graph.nodes, contains(node3));
        expect(graph.edges.length, 2);
        graph.removeAll();
        expect(graph.nodes.length, 0);
        expect(graph.edges.length, 0);
        expect(graph.nodes, isNot(contains([node1, node2, node3])));
        expect(graph.edges, isNot(contains([edge1, edge2])));
      });
    });
  });

  // NOTE: bad idea. the graph must not know about dragging at all!
  // group('drag()', () {
  //   late Node node;

  //   setUp(() async {
  //     node = Node(id: 1);
  //     graph.addNode(node);
  //   });
  //   test('it marks the node being dragged, so it is returned by .draggingNodes',
  //       () {
  //     graph.drag(node);
  //     expect(graph.nodes, contains(node));
  //     expect(graph.draggingNodes, contains(node));
  //   });
  // });
}
