import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class BasePresentation extends StatelessWidget {
  final double width = 50;
  final double height = 50;
  final GlobalKey key = GlobalKey();
  final Node node;
  final VoidCallback onAddPressed;

  BasePresentation({required this.node, required this.onAddPressed});

  Offset get offset {
    return node.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }
}
