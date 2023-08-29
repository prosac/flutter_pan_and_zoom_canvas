import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Graph model;

  group('Graph', () {
    setUp(() async {
      model = Graph();
    });

    group('nodes', () {
      test('initially is an empty list', () {
        expect(model.nodes, isA<List>());
      });
    });

    group('draggingNodes', () {
      test('initially is an empty list', () {
        expect(model.draggingNodes, isA<List>());
      });
    });

    group('edges', () {
      test('initially is an empty list', () {
        expect(model.edges, isA<List>());
      });
    });

    group('add(Node node)', () {
      test('adds nodes with incrementing serial numbers', () {
        model.addNode(Node.random());
        expect(model.nodes[0].id, 1);
        model.addNode(Node.random());
        expect(model.nodes[1].id, 2);
      });

      // TODO: how to test that it calls notifyListeners() on the ChangeNotifier mixin
      // test('calls notifyListeners()', () {
      //   expect(model, isMethodCall);
      //   model.addNode(Node(offset: Offset.zero, payload: TestData()));
      // });
    });

    group('addEdge(Node node, Node otherNode)', () {
      test('adds an Edge from node to node', () {
        model.addEdge(Edge(source: Node(dx: 0, dy: 0), destination: Node(dx: 0, dy: 0)));
        expect(model.edges[0], isA<Edge>());
      });
    });

    group('drag', () {
      late Node node1;
      late Node node2;

      setUp(() async {
        node1 = Node.random();
        node2 = Node.random();
        model.addNode(node1);
        model.addNode(node2);
      });
      test('moves it to the list of dragging nodes', () {
        model.drag(node1);
        expect(model.draggingNodes, contains(node1));
        expect(model.nodes, contains(node2));
      });
    });

    group('leaveDragginItemAtNewOffset', () {
      late Node node1;

      setUp(() async {
        node1 = Node.random();
        model.addNode(node1);
      });
      test('moves the node being dragged from dragging to normal and notifies', () {
        model.drag(node1);
        expect(Offset(node1.dx, node1.dy), Offset(100, 100));
      });
    });

    group('removing nodes', () {
      late Node node1;
      late Node node2;
      late Node node3;

      setUp(() async {
        node1 = Node.random();
        node2 = Node.random();
        node3 = Node.random();
        model.addNode(node1);
        model.addNode(node2);
        model.addNode(node3);
        model.addEdge(Edge(source: node1, destination: node2));
        model.addEdge(Edge(source: node2, destination: node3));
      });
      group('remove(Node node)', () {
        test('removes node and connected edges', () {
          expect(model.nodes, contains(node3));
          expect(model.edges.length, 2);
          model.removeNode(node3);
          expect(model.nodes, isNot(contains(node3)));
          expect(model.edges.length, 1);
        });
      });

      group('removeAll()', () {
        test('removes all nodes', () {
          expect(model.nodes, contains(node3));
          expect(model.edges.length, 2);
          model.removeAll();
          expect(model.nodes.length, 0);
          expect(model.edges.length, 0);
        });
      });
    });

    // group('connecting things', () {
    //   group('initiateConnecting()', () {
    //     test('sets connecting to true', () {
    //       var node = Node.random();
    //       expect(model.connecting, equals(false));
    //       model.initiateConnecting(node);
    //       expect(model.connecting, equals(true));
    //     });
    //     test('memoizes the given node as the one to be connected', () {
    //       var node = Node.random();
    //       expect(model.nodeToBeConnected, isNull);
    //       model.initiateConnecting(node);
    //       expect(model.nodeToBeConnected, equals(node));
    //     });
    //     test('adds an Edge connecting the node and a dragging temp Node that makes the Edge complete', () {
    //       var node = Node.random();
    //       expect(model.nodeToBeConnected, isNull);
    //       expect(model.draggingNodes, isNot(contains(model.tempNode)));
    //       model.initiateConnecting(node);
    //       expect(model.draggingNodes, contains(model.tempNode));
    //     });
    //   });
    // });
  });
}
