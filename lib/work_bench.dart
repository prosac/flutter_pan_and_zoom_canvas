import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'item_data.dart';
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
  double _backgroundAspectRatio;
  Text info = Text('sdfsdf');
  final List<ItemData> items = <ItemData>[];
  TransformationController _transformationController = TransformationController();

  Size _backgroundSize;
  double _constraintsAspectRatio;

  Background _background;
  double _scale;

  void _onRemoveItem(ItemData itemData) {
    setState(() => items.remove(itemData));
  }

  void _onAddItem(ItemData itemData) {
    setState(() => items.add(itemData));
  }

  void _onAcceptWithDetails(DragTargetDetails details, Size backgroundSize) {
    final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);

    final Offset offset = Offset(
      localOffset.dx / backgroundSize.width,
      localOffset.dy / backgroundSize.height,
    );

    _onAddItem(ItemData(offset: offset, width: 100, height: 100, testData: details.data));
  }

  @override
  void initState() {
    super.initState();
    _background = Background(width: widget.width, height: widget.height);
    _backgroundAspectRatio = _background.width.toDouble() / _background.height.toDouble();
    items.add(ItemData(offset: Offset(0, 0), width: 100, height: 100, testData: TestData()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      // the canvas and ui elements that are fixed to the viewport
      // TODO: the item must keep the size fitting the zoom level when dragging
      // TODO: the item must not jump under the cursor when dragging
      // TODO: the canvas must be bigger then the viewport on start and enable panning right away
      Center(
        child: InteractiveViewer(
            transformationController: _transformationController,
            // minScale: 1,
            // maxScale: 10,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              _constraintsAspectRatio = constraints.maxWidth / constraints.maxHeight;
              _backgroundSize = Size(
                _backgroundAspectRatio > _constraintsAspectRatio
                    ? constraints.maxWidth
                    : constraints.maxHeight * _backgroundAspectRatio,
                _backgroundAspectRatio > _constraintsAspectRatio
                    ? constraints.maxWidth / _backgroundAspectRatio
                    : constraints.maxHeight,
              );

              _scale = _transformationController.value.row0[0];

              return DragTarget(
                key: _dragTargetKey,
                onAcceptWithDetails: (DragTargetDetails details) {
                  _onAcceptWithDetails(details, _backgroundSize);
                },
                builder: (BuildContext context, List<TestData> candidateData, List rejectedData) {
                  return Stack(
                    children: <Widget>[
                      _background,
                      ...items
                          .map((ItemData itemData) => Positioned(
                                left: itemData.offset.dx * _backgroundSize.width,
                                top: itemData.offset.dy * _backgroundSize.height,
                                child: DraggableItem(
                                    testData: TestData(text: 'not dragging'),
                                    width: itemData.width,
                                    height: itemData.height,
                                    scale: _scale,
                                    onDragStarted: () {
                                      _onRemoveItem(itemData);
                                    }),
                              ))
                          .toList()
                    ],
                  );
                },
                // onWillAccept: () => true,
              );
            })),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 120,
          color: Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [Text('Viewport fixed')],
            ),
          ),
        ),
      )
    ]);
  }
}
