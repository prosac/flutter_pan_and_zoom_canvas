import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/test_data.dart';
import 'dart:math';

class Node extends Equatable {
  final int id;
  double dx, dy, width, height;
  final TestData payload = TestData();
  Node({this.id = 0, this.dx = 0, this.dy = 0, this.height = 200, this.width = 300});

  Offset get offset => Offset(dx, dy);

  set offset(Offset offset) {
    dx = offset.dx;
    dy = offset.dy;
  }

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
    //
    var id = Random().nextInt(1000);

    return Node(id: id, dx: 0, dy: 0);
  }
}
