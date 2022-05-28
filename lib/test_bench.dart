import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/simple_connection_painter.dart';

class TestBench extends StatefulWidget {
  TestBench({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;
  final double height;

  // super naive state management to keep all complexity out
  double? draggableLeft;
  double? draggableTop;
  GlobalKey draggableKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  @override
  TestBenchState createState() => TestBenchState();
}

class TestBenchState extends State<TestBench> {
  Ticker? ticker;

  Offset? currentDraggingThingOffset;

  Widget build(BuildContext context) {
    Positioned thing1 = buildStationary('1', 100.0, 100.0);
    Positioned thing2 = buildDraggable('2', 300.0, 200.0);

    CustomPaint connection = buildConnection(
        Offset(thing1.left ?? 0, thing1.top ?? 0),
        Offset(thing2.left ?? 0, thing2.top ?? 0));

    return InteractiveViewer(
        constrained: false,
        scaleEnabled: false,
        // maxScale: 10.0,
        // minScale: 0.01,
        // From Stack docs: The stack sizes itself to contain all the non-positioned children
        // ... that can have something to do with my problem
        child: createListener(Stack(key: widget.stackKey, children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(color: Colors.blue),
          ),
          thing1,
          thing2,
          connection
        ])));
  }

  Widget createListener(Widget child) {
    return Listener(
      child: child,
      onPointerMove: (PointerMoveEvent event) {
        print("x: ${event.position.dx}, y: ${event.position.dy}");
        setState(() {
          widget.draggableLeft = event.position.dx;
          widget.draggableTop = event.position.dy;
        });
      },
    );
  }

  // a minimal thing to show
  SizedBox buildPresentation(identifier, {width: 100.0, height: 100.0}) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
          child: Center(
              child: Text(identifier,
                  style: Theme.of(context).textTheme.headline2)),
          decoration: BoxDecoration(color: Colors.amber)),
    );
  }

  Positioned buildStationary(String identifier, double left, double top) {
    return Positioned(
        child: buildPresentation(identifier), left: left, top: top);
  }

  Positioned buildDraggable(String identifier, double left, double top) {
    return Positioned(
      left: widget.draggableLeft ?? left,
      top: widget.draggableTop ?? top,
      child: Draggable(
        key: widget.draggableKey,
        dragAnchorStrategy: (widget, context, offset) {
          final RenderBox renderObject =
              context.findRenderObject() as RenderBox;
          return renderObject.globalToLocal(offset);
        },
        feedback: buildPresentation(identifier),
        child: buildPresentation(identifier),
        childWhenDragging: Container(),
        onDragStarted: () {
          // startTicker(widget.draggableKey);
        },
        onDragEnd: (dragDetails) {
          // stopTicker();

          setState(() {
            widget.draggableLeft = dragDetails.offset.dx;
            widget.draggableTop = dragDetails.offset.dy;
          });
        },
      ),
    );
  }

  CustomPaint buildConnection(Offset offset1, Offset offset2) {
    return CustomPaint(
        painter: SimpleConnectionPainter(start: offset1, end: offset2));
  }

  void startTicker(GlobalKey key) {
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;

    this.ticker = Ticker((elapsed) {
      currentDraggingThingOffset = box.localToGlobal(Offset.zero);
      print("$currentDraggingThingOffset");
    });

    this.ticker?.start();
  }

  void stopTicker() {
    this.ticker?.stop();
  }
}
