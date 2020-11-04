import 'package:flutter/material.dart';

void main() => runApp(PanAndZoom());

class PanAndZoom extends StatelessWidget {
  static const String _title = 'Pan and Zoom';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: _title, home: WorkBench());
  }
}

class ExampleContent extends StatelessWidget {
  final itemColor;
  final label;

  const ExampleContent({Key key, this.label, this.itemColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      color: itemColor,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class DragBox extends StatefulWidget {
  final Offset initPos;
  final ExampleContent content;

  DragBox(this.initPos, this.content);

  @override
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);
  ExampleContent content;

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: Draggable(
          data: widget.content.itemColor,
          child: widget.content,
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              position = offset;
            });
          },
          feedback: widget.content,
          childWhenDragging: Container(),
        ));
  }
}

class ConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) async {
    final linePaint = Paint()
      ..color = Colors.red[800]
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = new Path()
      ..moveTo(200, 100)
      ..lineTo(100, 300)
      ..close();

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WorkBench extends StatelessWidget {
  WorkBench({Key key}) : super(key: key);

  final info = 'lalala';

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        minScale: 1,
        maxScale: 10,
        child: Stack(children: [
          _background(),
          Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                info,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              )),
          DragBox(Offset(0.0, 0.0),
              ExampleContent(label: 'One', itemColor: Colors.blueAccent)),
          DragBox(Offset(200.0, 0.0),
              ExampleContent(label: 'Two', itemColor: Colors.orange)),
          DragBox(Offset(300.0, 0.0),
              ExampleContent(label: 'Three', itemColor: Colors.lightGreen)),
          CustomPaint(painter: ConnectionPainter())
        ]));
  }

  Container _background() {
    return Container(
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
