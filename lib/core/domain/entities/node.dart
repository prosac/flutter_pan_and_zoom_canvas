class Node {
  double dx;
  double dy;
  final int id; // a simple and readable identifier for visual debugging

  Node({required this.id, required this.dx, required this.dy});

  @override
  String toString() {
    return '${this.id}:\n${this.dx}\n${this.dy}';
  }

  @override
  bool operator ==(Object other) {
    if (other is Node) {
      return id == other.id;
    }
    return false;
  }

  factory Node.random() {
    // var offset = Offset(
    //     Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
    // var payload = TestData();
    // var node = Node(offset: offset, payload: payload);
    // var presentation = ExamplePresentation(node: node, onAddPressed: () {});
    // node.presentation = presentation;
    // return node;

    return Node(id: 0, dx: 0, dy: 0);
  }
}
