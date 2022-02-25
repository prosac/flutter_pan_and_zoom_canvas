import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'conntection_painter.dart';
import 'draggable_item.dart';
import 'factories.dart';
import 'item.dart';
import 'model/connection.dart';
import 'neumorphic_background.dart';
import 'test_data.dart';
import 'model/graph_model.dart' as Model;

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
  final List<Item> items = <Item>[];
  final List<Item> draggingItems = <Item>[];
  late Background _background;
  late Size _backgroundSize = Size(_background.width, _background.height);
  late Offset _center = Offset(_backgroundSize.width/2, _backgroundSize.height/2);
  double _scale = 1.0;

  Model.GraphModel _nodeGraph = Model.GraphModel();

  // TODO: make Items a thing that manages the whole flutter centric part of
  // items on the workbench and put these methods there?
  void _dematerializeItem(item) {
    items.remove(item);
    draggingItems.add(item);
  }

  Iterable<CustomPaint> _drawConnections() {
    return items.map((Item item) {
      Offset offset = Offset(item.offset!.dx * _backgroundSize.width,
              item.offset!.dy * _backgroundSize.height) +
          Offset(item.width / 2, item.height / 2);

      return CustomPaint(
          painter: ConnectionPainter(start: Offset.zero, end: offset));
    });
  }

  void _materializeItemAtNewOffset(
      DragTargetDetails details, Size backgroundSize) {
    final RenderBox renderBox =
        _dragTargetKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.offset);

    final Offset offset = Offset(
      localOffset.dx / backgroundSize.width,
      localOffset.dy / backgroundSize.height,
    );

    // this is the item added after dragging
    // TODO: when we move this, we could pass setState of the workbench to the
    // items abstraction, so it can do the following on its own. :thinking:
    setState(() {
      Item item = draggingItems.removeLast();
      item.offset = offset;
      items.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: background variants should be injecatble
    _background =
        NeumorphicBackground(width: widget.width, height: widget.height);
    // _connections = context.read<ConnectionsModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          // return ConnectionsModel();
        },
        child: Stack(children: <Widget>[
          InteractiveViewer(
              maxScale: 10.0,
              minScale: 0.01,
              boundaryMargin:  EdgeInsets.all(1000.0),
              transformationController: _transformationController,
              onInteractionEnd: (details) {
                setState(() {
                  // doing this in a call to setState solves the problem that the feedback item does not know the current scale
                  _scale = _transformationController.value.row0[0];
                });
              },
              constrained:
                  false, // this does the trick to make the "canvas" bigger than the view port
              child: DragTarget(
                key: _dragTargetKey,
                onAcceptWithDetails: (DragTargetDetails details) {
                  _materializeItemAtNewOffset(details, _backgroundSize);
                },
                builder: (BuildContext context, List<TestData?> candidateData,
                    List rejectedData) {
                  return Stack(
                    children: <Widget>[
                      _background,
                      // ... the stuff representing the ongoing user interaction of drawing a new connection
                      // currentDrawing(),
                      // ... the existing connections between items on the workbench. for now just a quick sketch
                      // that draws connections from zero to every item
                      ..._drawConnections(),
                      ...items.map((Item item) {
                        Offset offset = Offset(
                            item.offset!.dx * _backgroundSize.width,
                            item.offset!.dy * _backgroundSize.height);

                        return DraggableItem(
                            key: UniqueKey(),
                            offset: offset,
                            scale: _scale,
                            item: item,
                            onDragStarted: () {
                              setState(() {
                                _dematerializeItem(item);
                              });
                            },
                            onDragUpdate: (DragUpdateDetails details) {});
                      }).toList(),
                      ..._nodeGraph.connections().map((Connection connection) {
                        RenderBox box1 = connection.node1.key.currentContext
                            .findRenderObject();
                        Offset offset1 = box1.localToGlobal(Offset.zero);

                        RenderBox box2 = connection.node1.key.currentContext
                            .findRenderObject();
                        Offset offset2 = box2.localToGlobal(Offset.zero);

                        return CustomPaint(
                            painter: ConnectionPainter(
                                start: offset1, end: offset2));
                      })
                    ],
                  );
                },
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Column(children: [
                ElevatedButton(
                    onPressed: () {
                      var matrix = Matrix4.identity();
                      matrix.translate(-_center.dx, -_center.dy);
                      _transformationController.value = matrix;
                      setState(() => _scale = 1.0);
                    },
                    child: Text('Reset')),
                Padding(padding: EdgeInsets.only(bottom: 10.0)),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Color randomColor = Colors.primaries[
                            Random().nextInt(Colors.primaries.length)];
                        items.add(buildItem(Offset.zero,
                            TestData(text: 'added...', color: randomColor)));
                      });
                    },
                    child: Text('Add thing')),
              ]))
        ]));
  }
}
