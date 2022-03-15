import 'node.dart';

class Connection {
  Connection(this.node1, this.node2);

  // TODO: nodes must exist! this is only because i want to solve the problem of creating
  // node AND presentation with null constraints later
  Node node1;
  Node node2;
}
