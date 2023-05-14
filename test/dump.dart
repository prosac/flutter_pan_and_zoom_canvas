// Dump for things while refactoring
// Node test
class MockRenderBox extends RenderBox {}

class MockPresentation extends BasePresentation {
  final GlobalKey key = GlobalKey();
  final double width = 50;
  final double height = 50;

  MockPresentation() : super(node: Node.random());

  RenderBox get renderBox => MockRenderBox();
  Widget build(BuildContext context) => Container();
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.error}) => '';
}

    test('actions', () {
      expect(node.actions, isA<List>());
    });
  group('A Node with presentation', () {
    late BasePresentation presentation;

    setUp(() async {
      node = Node(offset: Offset.zero, payload: TestData());
      presentation = MockPresentation();
      node.presentation = presentation;
    });

    test('delegates width and height to the presentation', () {
      expect(node.width, presentation.width);
      expect(node.height, presentation.height);
    });

    group('.renderBox', () {
      test('returns the RenderBox of the presentation', () {
        expect(node.renderBox, isA<RenderBox>());
      });
    });
  });

// Node test end

// Graph entity test

  final List<Node> draggingNodes = [];
  // Node? nodeToConnect;

    test('can notifyListeners()',
        () => expect(model.notifyListeners, isA<Function>()));

    group('draggingNodes', () {
      test('initially is an empty list', () {
        expect(model.draggingNodes, isA<List>());
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
      test('moves the node being dragged from dragging to normal and notifies', () {
        model.drag(node1);
        model.leaveDraggingItemAtNewOffset(Offset(100, 100));
        expect(node1.offset, Offset(100, 100));
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


    test('can notifyListeners()', () => expect(graph.notifyListeners, isA<Function>()));
// Graph entity test end

// GraphModel


  void drag(node) {
    nodes.remove(node);
    draggingNodes.add(node);
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    Node node = draggingNodes.removeLast();
    node.offset = offset;
    nodes.add(node);
  }

  void initiateConnecting(Node fromNode) {
    nodeToConnect = fromNode;
  }

  // void addEdgeTo(Node otherNode) {
  //   // TODO: what to do when there is no nodeToConnect?
  //   final edge = Edge(node: nodeToConnect!, otherNode: otherNode);
  //   if (edges.contains(edge)) return;
  //   edges.add(edge);
  //   nodeToConnect = null;
  // }
