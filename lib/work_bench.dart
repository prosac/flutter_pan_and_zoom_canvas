import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/factories.dart';
import 'package:flutter_pan_and_zoom/model/connection.dart';
import 'package:flutter_pan_and_zoom/simple_connection_painter.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'neumorphic_background.dart';
import 'test_data.dart';

class WorkBench extends StatefulWidget {
  WorkBench({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;
  final double height;

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> {
  final TransformationController _transformationController =
      TransformationController();

  final GlobalKey _dragTargetKey = GlobalKey();
  double _scale = 1.0;

  late Background background;
  late Offset center;
  late MediaQueryData mediaQueryData;

  @override
  void initState() {
    super.initState();
    background =
        NeumorphicBackground(width: widget.width, height: widget.height);
    center = Offset(background.width / 2, background.height / 2);
    _resetViewport();
  }

  @override
  Widget build(BuildContext context) {
    GraphModel model = Provider.of<GraphModel>(context);
    model.scale = _scale;

    mediaQueryData = MediaQuery.of(context);
    model.viewportSize = mediaQueryData.size;
    model.viewPortOrientation = mediaQueryData.orientation;

    model.interactiveViewerOffset = Offset(
        _transformationController.value.row0[3],
        _transformationController.value.row1[3]);

    return Stack(children: <Widget>[
      InteractiveViewer(
          maxScale: 10.0,
          minScale: 0.01,
          boundaryMargin: EdgeInsets.all(1000.0),
          transformationController: _transformationController,
          onInteractionEnd: (details) =>
              setState(() => _setScaleFromTransformationController()),
          constrained:
              false, // this does the trick to make the "canvas" bigger than the view port
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return DragTarget(
              key: _dragTargetKey,
              onAcceptWithDetails: (DragTargetDetails details) {
                final RenderBox renderBox = _dragTargetKey.currentContext!
                    .findRenderObject() as RenderBox;
                Offset offset = renderBox.globalToLocal(details.offset);
                model.leaveDraggingItemAtNewOffset(offset);
              },
              builder: (BuildContext context, List<TestData?> candidateData,
                  List rejectedData) {
                return Stack(
                    children: [background, ...connections, ...draggableItems]);
              },
            );
          })),
      Align(
          alignment: Alignment.topLeft,
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: _resetViewport, child: Text('Reset')),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  ElevatedButton(
                      onPressed: _deleteAllTheThings,
                      child: Text('Delete all the things')),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  ElevatedButton(
                      onPressed: () => addThing(model, center),
                      child: Text('Add thing'))
                ]);
          }))
    ]);
  }

  void _resetViewport() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    _transformationController.value = matrix;
    setState(() => _scale = 1.0);
    Provider.of<GraphModel>(context, listen: false).scale = 1.0;
  }

  // TODO: maybe this should be called something like GraphicalNodeRepresentation and thus graphicalNodeRepresentations
  List get draggableItems {
    GraphModel model = Provider.of<GraphModel>(context);

    return model.nodes.map((Node node) {
      Offset offset = node.offset;

      return DraggableItem(
          key: UniqueKey(),
          offset: offset,
          scale: _scale,
          node: node,
          onDragStarted: () {
            model.drag(node); // should implicitly do what setState does
            model.startTicker(node); // should be implicit!
          },
          onDragCompleted: () {
            print('onDragCompleted');
            model.stopTicker();
          },
          onDragEnd: (DraggableDetails details) {
            print('onDragEnd');
            print(details);
            // TODO: why is this never called?
            // maybe because it is always accepted by the big drag target?
          },
          onDragUpdate: (DragUpdateDetails details) {
            print('onDragUpdate');
            print(details);
          });
    }).toList();
  }

  List<CustomPaint> get connections {
    GraphModel model = Provider.of<GraphModel>(context);

    return model.connections.map((Connection connection) {
      Size size1 = Size(connection.node1.presentation!.width,
          connection.node1.presentation!.height);
      Size size2 = Size(connection.node2.presentation!.width,
          connection.node1.presentation!.height);

      Offset nodeOffset1 = connection.node1.presentation!.offset;
      Offset nodeOffset2 = connection.node2.presentation!.offset;

      Offset offset1AdaptedToBackground = nodeOffset1;
      Offset offset2AdaptedToBackground = nodeOffset2;

      Offset offset1 = Offset(offset1AdaptedToBackground.dx + size1.width / 2,
          offset1AdaptedToBackground.dy + size1.height / 2);
      Offset offset2 = Offset(offset2AdaptedToBackground.dx + size2.width / 2,
          offset2AdaptedToBackground.dy + size2.height / 2);

      return CustomPaint(
          painter: SimpleConnectionPainter(start: offset1, end: offset2));
    }).toList();
  }

  void _setScaleFromTransformationController() {
    // doing this in a call to setState solves the problem that the feedback item does not know the current scale
    _scale = _transformationController.value.row0[0];
    GraphModel model = Provider.of<GraphModel>(context, listen: false);
    model.scale = _scale;

    model.interactiveViewerOffset = Offset(
        _transformationController.value.row0[3],
        _transformationController.value.row1[3]);
  }

  void _deleteAllTheThings() {
    Provider.of<GraphModel>(context, listen: false).removeAll();
  }
}
