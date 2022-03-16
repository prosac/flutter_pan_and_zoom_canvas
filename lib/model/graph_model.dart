import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/connection.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  /// Internal, private state of the model.
  final List<Node> _nodes = [];
  final List<Node> _draggingNodes = [];
  final List<Connection> _connections = [];
  double scale = 1.0; // TODO: should come from the outside

  List<Node> get nodes => _nodes;
  List<Node> get draggingNodes => _draggingNodes;
  List<Connection> get connections => _connections;

  void add(Node node) {
    _nodes.add(node);
    notifyListeners();
  }

  void addFromExistingNode(Node existingNode, Node node) {
    _nodes.add(node);
    _connections.add(Connection(existingNode, node));
    notifyListeners();
  }

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

  void leaveDraggingItemAtNewOffset(Offset offset) {
    print('------');
    Node node = _draggingNodes.removeLast();
    node.offset = offset;
    _nodes.add(node);
    notifyListeners();
  }
}
