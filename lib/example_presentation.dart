import 'package:flutter/material.dart';

class ExamplePresentation extends StatelessWidget {
  final itemColor;
  final label;
  final double width = 300;
  final double height = 200;

  const ExamplePresentation({Key key, this.label, this.itemColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10.0),
        color: itemColor,
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
      ),
    );
  }
}
