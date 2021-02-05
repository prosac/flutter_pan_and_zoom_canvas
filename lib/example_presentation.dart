import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/presentation_container.dart';

class ExamplePresentation extends StatelessWidget {
  final color;
  final label;
  final double width = 300;
  final double height = 200;

  const ExamplePresentation({Key key, this.label, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresentationContainer(
      width: width,
      height: height,
      color: color,
      label: label,
      child: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text('Button'),
              onPressed: () {},
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            RaisedButton(
              child: Text('Button'),
              onPressed: () {},
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
