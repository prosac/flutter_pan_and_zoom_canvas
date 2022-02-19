import 'package:flutter/material.dart';

class ExampleContent extends StatelessWidget {
  final itemColor;
  final label;

  const ExampleContent({Key? key, this.label, this.itemColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        color: itemColor,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
