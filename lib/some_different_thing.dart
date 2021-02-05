import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/presentation_container.dart';

// Create a Form widget.
class SomeDifferentThing extends StatelessWidget {
  final color;
  final label;
  final double width = 300;
  final double height = 200;

  const SomeDifferentThing({Key key, this.label, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresentationContainer(
        width: width,
        height: height,
        color: color,
        label: label,
        child: Scaffold(
          appBar: AppBar(
            title: Text('title'),
            backgroundColor: Colors.black87,
          ),
          body: Container(
            // Add box decoration
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.indigo[800],
                  Colors.indigo[700],
                  Colors.indigo[600],
                  Colors.indigo[400],
                ],
              ),
            ),
            child: Center(
              child: ListView(
                children: <Widget>[
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('boom')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('boom')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('boom')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('lala')]),
                  Row(children: [Text('boom')]),
                  Row(children: [Text('lala')]),
                ],
              ),
            ),
          ),
        ));
  }
}
