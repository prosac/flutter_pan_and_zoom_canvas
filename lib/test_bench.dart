import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TestBench extends StatefulWidget {
  TestBench({Key? key, required this.width, required this.height}) : super(key: key);

  final double width;
  final double height;

  @override
  TestBenchState createState() => TestBenchState();
}

class TestBenchState extends State<TestBench> {
  Widget build(BuildContext context) {
    // GlobalKey thingKey = GlobalKey();
    // Positioned thing1 = buildPositionedThing('1', Offset(100.0, 100.0));
    // Positioned thing2 = buildPositionedThing('2', Offset(300.0, 100.0));
    Positioned thing1 = buildDraggable('1');
    Positioned thing2 = buildDraggable('2');

    return InteractiveViewer(
        constrained: false, maxScale: 10.0, minScale: 0.01, child: Stack(children: [thing1, thing2]));
  }

  // a minimal thing to show
  Container buildPresentation(identifier, {width: 100.0, height: 100.0}) {
    return Container(
        width: width,
        height: height,
        child: Center(child: Text(identifier, style: Theme.of(context).textTheme.labelLarge)),
        decoration: BoxDecoration(color: Colors.amber));
  }

  Positioned buildDraggable(String identifier) {
    return Positioned(
      child: Draggable(
          dragAnchorStrategy: (widget, context, offset) {
            final RenderBox renderObject = context.findRenderObject() as RenderBox;
            return renderObject.globalToLocal(offset);
          },
          feedback: buildPresentation(identifier),
          child: buildPresentation(identifier)),
    );
  }
}
