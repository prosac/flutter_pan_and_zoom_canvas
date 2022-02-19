import 'package:flutter/material.dart';
import 'background.dart';

class NeumorphicBackground extends StatelessWidget implements Background {
  const NeumorphicBackground({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300
    );
  }
}
