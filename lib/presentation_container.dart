import 'package:flutter/material.dart';

class PresentationContainer extends StatelessWidget {
  final color;
  final label;
  final double width;
  final double height;
  final Widget child;

  const PresentationContainer({Key key, this.width, this.height, this.label, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(width: width, height: height, padding: EdgeInsets.all(10.0), color: color, child: child),
    );
  }
}
