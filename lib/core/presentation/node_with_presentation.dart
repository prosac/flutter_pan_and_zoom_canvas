import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/data/test_data.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_action.dart';

// TODO: remove all the things that are in Node entity
// TODO: inherit from Node or node?
class NodeWithPresentation {
  Offset offset = Offset(0, 0);

  // TODO: find out how to maka null safe one to one relation
  late BasePresentation presentation;
  final TestData payload;
  int id = 0; // a simple and readable identifier for visual debugging
  late List<SimpleAction> actions;

  Node({required this.offset, required this.payload, this.actions = const []});

  get height => presentation.height;

  // TODO: if we manage the potential of having no presentation here
  // maybe we should go for a null object by default for presentation
  get width => presentation.width;
  get renderBox => presentation.renderBox;

  @override
  String toString() {
    return '${this.id}:\n${this.offset.dx}\n${this.offset.dy}';
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

    return Node(offset: Offset.zero, payload: TestData());
  }
}
