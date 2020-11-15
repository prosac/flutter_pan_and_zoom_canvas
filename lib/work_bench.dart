import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'item_data.dart';
import 'test_data.dart';

class WorkBench extends StatefulWidget {
  WorkBench({
    Key key,
    this.width,
    this.height
  }) :
      assert(width != null),
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

  void _onRemoveItem(ItemData itemData) {
    setState(() => items.remove(itemData));
  }

  void _onAddItem(ItemData itemData) {
    setState(() => items.add(itemData));
  }

  void _initCanvas() async => setState(() {});

  void _onAcceptWithDetails(DragTargetDetails details, Size size) {
    final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    final Offset offset = Offset(
      localOffset.dx / size.width,
      localOffset.dy / size.height,
    );
    _onAddItem(ItemData(offset: offset, testData: details.data));
  }

  @override
  void initState() {
    super.initState();
    _initCanvas();
    _background = Background(width: widget.width, height: widget.height);
    _backgroundAspectRatio = _background.width.toDouble() / _background.height.toDouble();
    items.add(ItemData(offset: Offset(0, 0), testData: TestData()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      // the canvas and ui elements that are fixed to the viewport
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

              return DragTarget(
                key: _dragTargetKey,
                onAcceptWithDetails: (DragTargetDetails details) {
                  _onAcceptWithDetails(details, _backgroundSize);
                },
                builder: (BuildContext context, List<TestData> candidateData, List rejectedData) {
                  // final double pieceSide = math.min(_boardSize.width, _boardSize.height) * _kPieceSizeVsBoard;
                  final double itemSize = math.min(_backgroundSize.width, _backgroundSize.height);

                  return Stack(
                    children: <Widget>[
                      _background,
                      ...items
                          .map((ItemData itemData) => Positioned(
                                left: itemData.offset.dx * _backgroundSize.width,
                                top: itemData.offset.dy * _backgroundSize.height,
                                child: DraggableItem(
                                    testData: TestData(),
                                    width: itemSize,
                                    height: itemSize,
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
