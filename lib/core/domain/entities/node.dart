import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/test_data.dart';
import 'dart:math';

class Node extends Equatable {
  final int id;
  final int createdAt = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt(); // ~/ is more efficient says dart...
  double dx, dy, width, height;
  dynamic data = TestData(); // TODO introduce interface to attach data to nodes?

  Node({this.id = 0, this.dx = 0, this.dy = 0, this.height = 200, this.width = 300, this.data});

  Offset get offset => Offset(dx, dy);

  set offset(Offset offset) {
    dx = offset.dx;
    dy = offset.dy;
  }

  @override
  String toString() {
    return 'id: ${this.id}\ndx: ${this.dx}\ndy: ${this.dy}\n${this.createdAt}';
  }

  @override
  List<Object> get props => [id];

  factory Node.random() {
    var offset = Offset(Random().nextInt(4000).toDouble(), Random().nextInt(4000).toDouble());
    var id = Random().nextInt(1000);

    return Node(id: id, dx: offset.dx, dy: offset.dy, data: TestData());
  }
}
