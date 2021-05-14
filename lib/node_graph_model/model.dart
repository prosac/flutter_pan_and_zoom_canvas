import 'package:flutter_pan_and_zoom/node_graph_model/node.dart';

class Model {
  Model();

  List<Node> _nodes = List<Node>.empty(growable: true);
  List<Connection> _connections = List<Connection>.empty(growable: true);

  List<Node> nodes() => _nodes;
  List<Connection> connections() => _connections;

  void addNode(Node node) {
    _nodes.add(node);
  }

  void addConnection(startNode, endNode) {
    _connections.add(Connection(startNode, endNode));
  }
}