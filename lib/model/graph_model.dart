import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/connection.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  /// Internal, private state of the model.
  final List<Node> _nodes = [];
  final List<Node> _draggingNodes = [];
  final List<Connection> _connections = [];
  Ticker? ticker;
  late Size viewportSize;
  late Orientation viewPortOrientation;
  late double aspectRatio;
  double scale = 1.0; // TODO: should come from the outside
  Size? backgroundSize;
  Offset? center;

  Offset interactiveViewerOffset = Offset.zero;

  List<Node> get nodes => _nodes;
  List<Node> get draggingNodes => _draggingNodes;
  List<Connection> get connections => _connections;

  set connections(connection) {
    _connections.add(connection);
  }

  void add(Node node) {
    _nodes.add(node);
    node.serialNumber = nextSerialNumber();
    notifyListeners();
  }

  // void addFromExistingNode(Node existingNode, Node newNode) {
  //   newNode.serialNumber = nextSerialNumber();
  //   _nodes.add(newNode);
  //   _connections.add(Connection(existingNode, newNode));
  //   notifyListeners();
  // }

  void remove(node) {
    _nodes.remove(node);
    _connections.removeWhere((connection) => connection.nodesInclude(node));
    notifyListeners();
  }

  void removeAll() {
    _connections.clear();
    _nodes.clear();
    notifyListeners();
  }

  void drag(node) {
    _nodes.remove(node);
    _draggingNodes.add(node);
    notifyListeners();
  }

  void startTicker(Node node) {
    // TODO: make all this stuff nullsave
    RenderBox box =
        node.presentation?.key.currentContext?.findRenderObject() as RenderBox;

    ticker = Ticker((elapsed) {
      double elacs = pow(scale, -1).toDouble();
      // Offset adjustment = Offset(aspectRatio * scale, aspectRatio * scale);
      // Offset adjustment = Offset(aspectRatio * elacs, aspectRatio * elacs);
      // Offset adjustment = interactiveViewerOffset * scale;
      Offset offset = box.localToGlobal(Offset.zero).scale(elacs, elacs) +
          Offset(-interactiveViewerOffset.dx * elacs,
              -interactiveViewerOffset.dy * elacs);
      // .scale(aspectRatio, aspectRatio)
      // .translate(interactiveViewerOffset.dx, interactiveViewerOffset.dy);
      // .scale(aspectRatio, aspectRatio)
      // .scale(scale, scale);
      // Offset offset = box.localToGlobal(adjustment);
      // print('tick: ${offset.dx}, ${offset.dy}');
      node.offset = offset;
      notifyListeners();
    });

    ticker?.start();
  }

  void stopTicker() {
    ticker?.stop();
  }

  int nextSerialNumber() {
    return _nodes.map((node) => node.serialNumber).reduce(max) + 1;
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    Node node = _draggingNodes.removeLast();
    node.offset = offset;
    _nodes.add(node);
    notifyListeners();
    print('dragged node ${node.serialNumber}');
    print('${node.toString()}');
  }
}
