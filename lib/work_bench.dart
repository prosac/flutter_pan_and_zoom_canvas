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
  late Background _background;
  late Size _backgroundSize = Size(_background.width, _background.height);
  late Offset _center =
      Offset(_backgroundSize.width / 2, _backgroundSize.height / 2);
  double _scale = 1.0;

  // Offset _newGlobalOffset(RenderBox renderBox, Offset globalOffset, Size backgroundSize) {
  //   final Offset localOffset = renderBox.globalToLocal(globalOffset);

  //   return Offset(
  //     localOffset.dx / backgroundSize.width,
  //     localOffset.dy / backgroundSize.height,
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _background =
        NeumorphicBackground(width: widget.width, height: widget.height);
    _resetViewport();
  }

  @override
  Widget build(BuildContext context) {
    // Offset correctedCenter =
    //     Offset(_center.dx / _backgroundSize.width, _center.dy / _backgroundSize.height);
    Offset correctedCenter = _center;
    GraphModel model = Provider.of<GraphModel>(context);
    model.backgroundSize = _backgroundSize;
    model.center =
        Offset(_backgroundSize.height / 2, _backgroundSize.height / 2);
    model.scale = _scale;

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
                // GraphModel model = Provider.of<GraphModel>(context, listen: false);
                final RenderBox renderBox = _dragTargetKey.currentContext!
                    .findRenderObject() as RenderBox;
                // Offset offset = _newGlobalOffset(renderBox, details.offset, _backgroundSize);
                Offset offset = renderBox.globalToLocal(details.offset);
                model.leaveDraggingItemAtNewOffset(offset);
              },
              builder: (BuildContext context, List<TestData?> candidateData,
                  List rejectedData) {
                return Stack(children: [
                  _background,
                  ..._connections(model),
                  ..._nodes(model)
                ]);
              },
            );
          })),
      Align(
          alignment: Alignment.topLeft,
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: _resetViewport, child: Text('Reset')),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  ElevatedButton(
                      onPressed: _deleteAllTheThings,
                      child: Text('Delete all the things')),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  ElevatedButton(
                      onPressed: () => addThing(model, correctedCenter),
                      child: Text('Add thing')),
                  Text('Nodes: ${model.nodes.length}',
                      style: Theme.of(context).textTheme.bodyText1),
                  ...model.nodes.map((node) {
                    return Text('${node.toString()}',
                        style: Theme.of(context).textTheme.bodyText1);
                  }).toList(),
                  Text('Dragging nodes: ${model.draggingNodes.length}',
                      style: Theme.of(context).textTheme.bodyText1),
                  ...model.draggingNodes.map((node) {
                    return Text('${node.toString()}',
                        style: Theme.of(context).textTheme.bodyText1);
                  }).toList(),
                  Text('Connections: ${model.connections.length}',
                      style: Theme.of(context).textTheme.bodyText1),
                  ...model.connections.map((connection) {
                    return Text('${connection.toString()}',
                        style: Theme.of(context).textTheme.bodyText1);
                  }).toList()
                ]);
          }))
    ]);
  }

  void _resetViewport() {
    var matrix = Matrix4.identity();
    matrix.translate(-_center.dx, -_center.dy);
    _transformationController.value = matrix;
    setState(() => _scale = 1.0);
    Provider.of<GraphModel>(context, listen: false).scale = 1.0;
  }

  List _nodes(model) {
    return model.nodes.map((Node node) {
      // Offset offset = Offset(node.offset.dx * _backgroundSize.width, node.offset.dy * _backgroundSize.height);
      Offset offset = node.offset;

      return DraggableItem(
          key: UniqueKey(),
          offset: offset,
          scale: _scale,
          node: node,
          onDragStarted: () {
            model.drag(node); // should implicitly do what setState does
            model.startTicker(node);
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

  List<CustomPaint> _connections(GraphModel model) {
    return model.connections.map((Connection connection) {
      Size size1 = Size(connection.node1.presentation!.width,
          connection.node1.presentation!.height);
      Size size2 = Size(connection.node2.presentation!.width,
          connection.node1.presentation!.height);

      Offset nodeOffset1 = connection.node1.presentation!.offset;
      Offset nodeOffset2 = connection.node2.presentation!.offset;

      // Offset offset1AdaptedToBackground = Offset(nodeOffset1.dx * _backgroundSize.width, nodeOffset1.dy * _backgroundSize.height);
      // Offset offset2AdaptedToBackground = Offset(nodeOffset2.dx * _backgroundSize.width, nodeOffset2.dy * _backgroundSize.height);

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
    Provider.of<GraphModel>(context, listen: false).scale = _scale;
  }

  void _deleteAllTheThings() {
    Provider.of<GraphModel>(context, listen: false).removeAll();
  }
}
