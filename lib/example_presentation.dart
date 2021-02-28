import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
        child:
            NeumorphicButton(
              onPressed: () {
                print("onClick");
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
                color: Colors.grey.shade200
              ),
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                Icons.favorite_border,
                color: _iconsColor(context),
              ),
              duration: Duration(milliseconds: 50),
            ),
            // Padding(padding: EdgeInsets.only(top: 10)),
      )
    );
  }

  Color _iconsColor(BuildContext context) {
    return Colors.grey.shade400;
  }

  // TODO: introduce themes!
  // Color _iconsColor(BuildContext context) {
  //   final theme = NeumorphicTheme.of(context);
  //   if (theme.isUsingDark) {
  //     return theme.current.accentColor;
  //   } else {
  //     return null;
  //   }
  // }
  //
  // Color _textColor(BuildContext context) {
  //   if (NeumorphicTheme.isUsingDark(context)) {
  //     return Colors.white;
  //   } else {
  //     return Colors.black;
  //   }
  // }
}
