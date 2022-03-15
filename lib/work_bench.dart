import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'factories.dart';
import 'neumorphic_background.dart';
import 'test_data.dart';
import 'model/graph_model.dart';
import 'model/node.dart';

class WorkBench extends StatefulWidget {
  WorkBench({Key? key, required this.width, required this.height}) : super(key: key);

  final double width;
  final double height;

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> {
  final TransformationController _transformationController = TransformationController();

  final GlobalKey _dragTargetKey = GlobalKey();
  late Background _background;
  late Size _backgroundSize = Size(_background.width, _background.height);
  late Offset _center = Offset(_backgroundSize.width / 2, _backgroundSize.height / 2);
  double _scale = 1.0;

  // Iterable<CustomPaint> _drawConnections() {
  //   return items.map((Item item) {
  //     Offset offset = Offset(item.offset.dx * _backgroundSize.width, item.offset.dy * _backgroundSize.height) +
  //         Offset(item.width / 2, item.height / 2);

  //     return CustomPaint(painter: ConnectionPainter(start: Offset.zero, end: offset));
  //   });
  // }

  Offset _newGlobalOffset(RenderBox renderBox, Offset globalOffset, Size backgroundSize) {
    final Offset localOffset = renderBox.globalToLocal(globalOffset);

    return Offset(
      localOffset.dx / backgroundSize.width,
      localOffset.dy / backgroundSize.height,
    );
  }

  @override
  void initState() {
    super.initState();
    _background = NeumorphicBackground(width: widget.width, height: widget.height);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      InteractiveViewer(
          maxScale: 10.0,
          minScale: 0.01,
          boundaryMargin: EdgeInsets.all(1000.0),
          transformationController: _transformationController,
          onInteractionEnd: (details) => setState(() => _setScaleFromTransformationController()),
          constrained: false, // this does the trick to make the "canvas" bigger than the view port
          child: DragTarget(
            key: _dragTargetKey,
            onAcceptWithDetails: (DragTargetDetails details) {
              print('onAcceptWithDetails');
              GraphModel model = Provider.of<GraphModel>(context, listen: false);
              final RenderBox renderBox = _dragTargetKey.currentContext!.findRenderObject() as RenderBox;
              Offset offset = _newGlobalOffset(renderBox, details.offset, _backgroundSize);
              model.leaveDraggingItemAtNewOffset(offset);
              print('Offset ${offset.dx}, ${offset.dy}');
            },
            builder: (BuildContext context, List<TestData?> candidateData, List rejectedData) {
              return Consumer<GraphModel>(builder: (context, model, child) {
                return Stack(children: [
                  _background,
                  ..._nodes(model),
                  ..._connections(model)
                ]);
              });
            },
          )),
      Align(
          alignment: Alignment.centerLeft,
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return Column(children: [
              ElevatedButton(
                  onPressed: _resetViewport,
                  child: Text('Reset')),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
                ElevatedButton(
                    onPressed: () {
                      model.add(buildNode(Offset.zero, TestData(text: 'added...', color: Colors.red)));
                    },
                    child: Text('Add thing')),
                Text('Nodes: ${model.nodes.length}\nDragging: ${model.draggingNodes.length}', style: Theme.of(context).textTheme.bodySmall),
                ...model.nodes.map((node) {
                  return Text('${node.toString()}', style: Theme.of(context).textTheme.bodySmall);
              }).toList()
            ]);}))
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
      Offset offset = Offset(node.offset.dx * _backgroundSize.width, node.offset.dy * _backgroundSize.height);

      return DraggableItem(
          key: UniqueKey(),
          offset: offset,
          scale: _scale,
          node: node,
          onDragStarted: () {
            model.drag(node); // should implicitly do what setState does
          },
          onDragUpdate: (DragUpdateDetails details) {});
    }).toList();
  }

  List<CustomPaint> _connections(GraphModel model) {
    // return model.connections.map((Connection connection) {
    //   RenderBox box1 = connection.node1.key.currentContext?.findRenderObject() as RenderBox;
    //   Offset offset1 = box1.localToGlobal(Offset.zero);

    //   RenderBox box2 = connection.node2.key.currentContext?.findRenderObject() as RenderBox;
    //   Offset offset2 = box2.localToGlobal(Offset.zero);

    //   return CustomPaint(painter: SimpleConnectionPainter(start: offset1, end: offset2));
    // }).toList();
    return [];
  }

  void _setScaleFromTransformationController() {
    // doing this in a call to setState solves the problem that the feedback item does not know the current scale
    _scale = _transformationController.value.row0[0];
    Provider.of<GraphModel>(context, listen: false).scale = _scale;
  }
}
