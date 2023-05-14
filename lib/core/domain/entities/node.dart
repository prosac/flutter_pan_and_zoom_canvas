import 'package:equatable/equatable.dart';

class Node extends Equatable {
  int id;
  // List<Edge> edges = [];
  double dx, dy, width, height;

  Node({this.id = 0, this.dx = 0, this.dy = 0, this.height = 200, this.width = 300});

  // TODO: is it really required that a Node knows its edges?
  // void addEdge(Edge edge) {
  //   edges.add(edge);
  // }

  @override
  String toString() {
    return '${this.id}:\n${this.dx}\n${this.dy}';
  }

  @override
  List<Object> get props => [id];

  factory Node.random() {
    // var offset = Offset(
    //     Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
    // var payload = TestData();
    // var node = Node(offset: offset, payload: payload);
    // var presentation = ExamplePresentation(node: node, onAddPressed: () {});
    // node.presentation = presentation;
    // return node;

    return Node(dx: 0, dy: 0);
  }
}
