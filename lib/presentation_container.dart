import 'package:flutter/material.dart';

class PresentationContainer extends StatelessWidget {
  final color;
  final label;
  final double? width;
  final double? height;
  final Widget? child;

  const PresentationContainer({super.key, this.width, this.height, this.label, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10.0),
        child: child,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
