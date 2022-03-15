import 'node.dart';

class Connection {
  Connection(this.node1, this.node2);

  final Node node1;
  final Node node2;

  @override
  String toString() {
    return '${node1.offset} ${node2.offset}';
  }

  bool nodesInclude(node) {
    return (node == node1 || node == node2);
  }
}
