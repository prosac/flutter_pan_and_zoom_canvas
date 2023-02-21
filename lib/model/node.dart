import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/simple_action.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';

class Node {
  Offset offset = Offset(0, 0);
  // TODO: find out how to maka null safe one to one relation
  late BasePresentation presentation;
  final TestData payload;
  int serialNumber = 0; // a simple and readable identifier for visual debugging
  late List<SimpleAction> actions;

  Node({required this.offset, required this.payload, this.actions = const []});

  get height => presentation.height;

  // TODO: if we manage the potential of having no presentation here
  // maybe we should go for a null object by default for presentation
  get width => presentation.width;
  get renderBox => presentation.renderBox;

  @override
  String toString() {
    return '${this.serialNumber}:\n${this.offset.dx}\n${this.offset.dy}';
  }

  @override
  bool operator ==(Object other) {
    if (other is Node) {
      return serialNumber == other.serialNumber;
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
