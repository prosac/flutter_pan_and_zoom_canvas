import 'node.dart';

import 'connection.dart';

class GraphModel {
  GraphModel();

  List<Node> _nodes = List<Node>.empty(growable: true);
  List<Connection> _connections = List<Connection>.empty(growable: true);

  List<Node> nodes() => _nodes;
  List<Connection> connections() => _connections;

  void addNode(Node node) {
    _nodes.add(node);
  }

  void addConnection(node1, node2) {
    _connections.add(Connection(node1, node2));
  }
}
