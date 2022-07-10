import 'node.dart';

class Edge {
  Edge(this.node1, this.node2);

  final Node node1;
  final Node node2;

  @override
  String toString() {
    return '${node1.offset} ${node2.offset}';
  }

  bool isConnectedTo(node) {
    return (node == node1 || node == node2);
  }
}
