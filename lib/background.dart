import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.white24, Colors.black87],
          stops: <double>[0.0, 1.0],
        ),
      ),
    );
  }
}
