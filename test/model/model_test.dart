import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
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

    group('interactiveViewerOffset', () {
      test('is zero initially', () {
        expect(model.interactiveViewerOffset, Offset.zero);
      });
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

    group('ticker', () {
      test('is a Ticker', () {
        expect(model.ticker, isA<Ticker>());
      });
      test('initially is not ticking', () {
        expect(model.ticker.isTicking, false);
      });

      test('initially is not active', () {
        expect(model.ticker.isActive, false);
      });
    });

    group('scale', () {
      test('is 1.0 intitially', () {
        expect(model.scale, 1.0);
      });
    });

    group('add(Node node)', () {
      test('adds nodes with incrementing serial numbers', () {
        model.add(Node(offset: Offset.zero, payload: TestData()));
        expect(model.nodes[0].serialNumber, 1);
        model.add(Node(offset: Offset.zero, payload: TestData()));
        expect(model.nodes[1].serialNumber, 2);
      });

      // TODO: how to test that it calls notifyListeners() on the ChangeNotifier mixin
      // test('calls notifyListeners()', () {
      //   expect(model, isMethodCall);
      //   model.add(Node(offset: Offset.zero, payload: TestData()));
      // });
    });

    group('add(Node node)', () {
      test('adds nodes with incrementing serial numbers', () {
        model.add(Node(offset: Offset.zero, payload: TestData()));
        expect(model.nodes[0].serialNumber, 1);
        model.add(Node(offset: Offset.zero, payload: TestData()));
        expect(model.nodes[1].serialNumber, 2);
      });
    });

    group('addEdge(Node node, Node otherNode)', () {
      test('adds an Edge from node to node', () {
        model.addEdge(Node(offset: Offset.zero, payload: TestData()),
            Node(offset: Offset.zero, payload: TestData()));
        expect(model.edges[0], isA<Edge>());
      });
    });
  });
}
