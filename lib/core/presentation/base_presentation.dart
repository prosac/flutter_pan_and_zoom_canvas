import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class MockRenderBox extends RenderBox {}

abstract class AbstractPresentation extends StatelessWidget {
  final double width = 0;
  final double height = 0;
  final GlobalKey key = GlobalKey();
  final Node node = Node.random();
  final VoidCallback onAddPressed = () {};

  Offset get offset => Offset.zero;
  RenderBox get renderBox => MockRenderBox();

  @override
  Widget build(BuildContext context) => Container();
}

class BasePresentation extends AbstractPresentation {
  final double width = 50;
  final double height = 50;
  final GlobalKey key = GlobalKey();
  final Node node;

  BasePresentation({required this.node});

  Offset get offset {
    return node.offset;
  }

  RenderBox get renderBox => key.currentContext?.findRenderObject() as RenderBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }
}
