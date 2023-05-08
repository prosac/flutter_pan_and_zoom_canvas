class Node {
  double dx, dy, width, height;
  int id;

  Node({this.id = 0, required this.dx, required this.dy, this.height = 200, this.width = 300});

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

    return Node(dx: 0, dy: 0);
  }
}
