import 'node.dart';

class Edge {
  Edge(this.node1, this.node2);

  final Node node1;
  final Node node2;

  bool isConnectedTo(node) {
    return (node == node1 || node == node2);
  }
}
