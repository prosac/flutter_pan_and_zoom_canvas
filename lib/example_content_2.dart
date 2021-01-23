import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExampleContent2 extends StatelessWidget {
  final itemColor;
  final label;

  const ExampleContent2({Key key, this.label, this.itemColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
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
