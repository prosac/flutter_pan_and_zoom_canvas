import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/conntection_painter.dart';
import 'package:flutter_pan_and_zoom/neumorphic_background.dart';
import 'package:flutter_pan_and_zoom/some_different_thing.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'example_presentation.dart';
import 'item.dart';
import 'test_data.dart';

class WorkBench extends StatefulWidget {
  WorkBench({Key key, this.width, this.height})
      : assert(width != null),
        assert(height != null),
        super(key: key);

  final double width;
  final double height;

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> {
  final GlobalKey _dragTargetKey = GlobalKey();
  final List<Item> items = <Item>[];
  final List<Item> draggingItems = <Item>[];
  TransformationController _transformationController = TransformationController();

  Size _backgroundSize;
  Background _background;
  double _scale = 1.0;

  Item buildItem(Offset offset, TestData payload) {
    return Item(
        offset: offset, payload: payload, presentation: ExamplePresentation(label: payload.text, color: payload.color));
  }

  Item buildDifferentItem(Offset offset, TestData payload) {
    return Item(
        offset: offset, payload: payload, presentation: SomeDifferentThing(label: payload.text, color: payload.color));
  }

  void _dematerializeItem(item) {
    items.remove(item);
    draggingItems.add(item);
  }

  void _materializeItemAtNewOffset(DragTargetDetails details, Size backgroundSize) {
    final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);

    final Offset offset = Offset(
      localOffset.dx / backgroundSize.width,
      localOffset.dy / backgroundSize.height,
    );

    // this is the item added after dragging
    setState(() {
      Item item = draggingItems.removeLast();
      item.offset = offset;
      items.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    _background = NeumorphicBackground(width: widget.width, height: widget.height);
    _backgroundSize = Size(4000, 3000);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      InteractiveViewer(
          transformationController: _transformationController,
          onInteractionEnd: (details) {
            setState(() {
              // doing this in a call to setState solves the problem that the feedback item does not know the current scale
              _scale = _transformationController.value.row0[0];
            });
          },
          constrained: false, // this does the trick to make the "canvas" bigger than the view port
          child: DragTarget(
            key: _dragTargetKey,
            onAcceptWithDetails: (DragTargetDetails details) {
              _materializeItemAtNewOffset(details, _backgroundSize);
            },
            builder: (BuildContext context, List<TestData> candidateData, List rejectedData) {
              return Stack(
                children: <Widget>[
                  _background,
                  ...items.map((Item item) {
                    Offset offset =
                      Offset(item.offset.dx * _backgroundSize.width, item.offset.dy * _backgroundSize.height)
                      + Offset(item.width / 2, item.height / 2);

                    return CustomPaint(painter: ConnectionPainter(start: Offset.zero, end: offset));
                  }),
                  ...items.map((Item item) {
                    Offset offset =
                        Offset(item.offset.dx * _backgroundSize.width, item.offset.dy * _backgroundSize.height);

                    return DraggableItem(
                        offset: offset,
                        scale: _scale,
                        item: item,
                        onDragStarted: () {
                          setState(() {
                            _dematerializeItem(item);
                          });
                        });
                  }).toList()
                ],
              );
            },
          )),
      Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            RaisedButton(
                onPressed: () {
                  _transformationController.value = Matrix4.identity();
                  setState(() => _scale = 1.0);
                },
                child: Text('Reset')),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            RaisedButton(
                onPressed: () {
                  setState(() {
                    Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                    items.add(buildItem(Offset.zero, TestData(text: 'added...', color: randomColor)));
                  });
                },
                child: Text('Add thing')),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            RaisedButton(
                onPressed: () {
                  setState(() {
                    Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                    items.add(buildDifferentItem(Offset.zero, TestData(text: 'added...', color: randomColor)));
                  });
                },
                child: Text('Add a different thing')),
          ]))
    ]);
  }
}
