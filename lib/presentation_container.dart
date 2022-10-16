import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PresentationContainer extends StatelessWidget {
  final color;
  final label;
  final double? width;
  final double? height;
  final Widget? child;

  const PresentationContainer(
      {super.key, this.width, this.height, this.label, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Neumorphic(
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(10.0),
              child: child),
        ));
  }
}
