import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GraphModel model;

  group('GraphModel', () {
    setUp(() async {
      model = GraphModel();
    });

    test('is a Model ;-)', () => expect(model, isA<GraphModel>()));

    test('can notifyListeners()',
        () => expect(model.notifyListeners, isA<Function>()));

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
        model.add(Node.random());
        expect(model.nodes[0].serialNumber, 1);
        model.add(Node.random());
        expect(model.nodes[1].serialNumber, 2);
      });

      // TODO: how to test that it calls notifyListeners() on the ChangeNotifier mixin
      // test('calls notifyListeners()', () {
      //   expect(model, isMethodCall);
      //   model.add(Node(offset: Offset.zero, payload: TestData()));
      // });
    });

    group('addEdge(Node node, Node otherNode)', () {
      test('adds an Edge from node to node', () {
        model.addEdge(Node(offset: Offset.zero, payload: TestData()),
            Node(offset: Offset.zero, payload: TestData()));
        expect(model.edges[0], isA<Edge>());
      });
    });

    group('drag', () {
      late Node node1;
      late Node node2;

      setUp(() async {
        node1 = Node.random();
        node2 = Node.random();
        model.add(node1);
        model.add(node2);
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
        model.add(node1);
      });
      test('moves the node being dragged from dragging to normal and notifies',
          () {
        model.drag(node1);
        model.leaveDraggingItemAtNewOffset(Offset(100, 100));
        expect(node1.offset, Offset(100, 100));
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
        model.add(node1);
        model.add(node2);
        model.add(node3);
        model.addEdge(node1, node2);
        model.addEdge(node2, node3);
      });
      group('remove(Node node)', () {
        test('removes node and connected edges', () {
          expect(model.nodes, contains(node3));
          expect(model.edges.length, 2);
          model.remove(node3);
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
  });
}
