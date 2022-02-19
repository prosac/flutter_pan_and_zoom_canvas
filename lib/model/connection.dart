import 'node.dart';

class Connection {
  Connection(this.node1, this.node2);
  // Connection(this.node1, this.node2) : assert(node1 != null), assert(node2 != null);

  Node node1;
  Node node2;
}