import 'package:flutter/material.dart';

class PresentationContainer extends StatelessWidget {
  final color;
  final label;
  final double? width;
  final double? height;
  final Widget? child;

  const PresentationContainer({Key? key, this.width, this.height, this.label, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(10.0),
          // color: color, // TODO: how to work with color? maybe the injected color could act as the accent color?
          child: child,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // color: Colors.grey.shade300, // TODO: how to work with color themes? i do not want to explicit color names all over the world
              // https://api.flutter.dev/flutter/painting/LinearGradient-class.html
              gradient: LinearGradient(
                // begin: Alignment.topLeft,
                // end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade200
                ],
                // tileMode: TileMode.repeated, // repeats the gradient over the canvas
              ),
              boxShadow: [
                BoxShadow(
                    offset: Offset(10, 10),
                    color: Colors.black38,
                    blurRadius: 20),
                BoxShadow(
                    offset: Offset(-10, -10),
                    color: Colors.white.withOpacity(0.85),
                    blurRadius: 20)
              ])
      ),
    );
  }
}
