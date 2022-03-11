import 'package:flutter/widgets.dart';

import 'node.dart';

class GraphModel with ChangeNotifier {
  /// Internal, private state of the model.
  final List<Node> _nodes = [];
  final List<Node> _draggingNodes = [];

  List<Node> get nodes => _nodes;
  List<Node> get draggingNodes => _draggingNodes;

  void add(Node node) {
    _nodes.add(node);
    notifyListeners();
    print('Adding. Nodes in list ${_nodes.length}');
  }

  void remove(node) {
    _nodes.remove(node);
    notifyListeners();
    print('Removing. Nodes in list ${_nodes.length}');
  }

  /// Removes all items from the model.
  void removeAll() {
    _nodes.clear();
    notifyListeners();
  }

  void drag(node) {
    print('Dragging ${node.toString()}');
    _nodes.remove(node);
    print('Nodes ${_nodes.length}');
    _draggingNodes.add(node);
    print('Dragging nodes ${_draggingNodes.length}');
    notifyListeners();
  }

  void leaveDraggingItemAtNewOffset(Offset offset) {
    print('------');
    Node node = _draggingNodes.removeLast();
    print('Stopping to drag node ${node.toString()}');
    print('Putting node ${node.toString()} to new offset');
    node.offset = offset;
    _nodes.add(node);
    print('Dragging nodes ${_draggingNodes.length}');
    print('Nodes ${_nodes.length}');
    notifyListeners();
  }
}
