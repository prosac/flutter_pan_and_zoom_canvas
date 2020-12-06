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
  final List<ItemData> items = <ItemData>[];
  TransformationController _transformationController = TransformationController();

  Size _backgroundSize;
  Background _background;
  double _scale = 1.0;

  void _onRemoveItem(ItemData itemData) {
    setState(() => items.remove(itemData));
  }

  void _onAcceptWithDetails(DragTargetDetails details, Size backgroundSize) {
    final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);

    final Offset offset = Offset(
      localOffset.dx / backgroundSize.width,
      localOffset.dy / backgroundSize.height,
    );

    // this is the item added after dragging
    setState(() => items.add(ItemData(offset: offset, width: 100, height: 100, testData: details.data)));
  }

  @override
  void initState() {
    super.initState();
    _background = Background(width: widget.width, height: widget.height);
    _backgroundSize = Size(4000, 3000);
    // this is the initially added item
    items.add(ItemData(offset: Offset(0, 0), width: 100, height: 100, testData: TestData()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      // TODO: the item must not jump under the cursor when dragging
      Center(
        child: InteractiveViewer(
            transformationController: _transformationController,
            onInteractionEnd: (details) {
              setState(() {
                _scale = _transformationController.value.row0[0]; // doing this in a call to setState solves the problem that the feedback item does not know the current scale
              });
            },
            constrained: false, // this does the trick to make the "canvas" bigger than the view port
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
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
                              .map((ItemData itemData) =>
                              Positioned(
                                left: itemData.offset.dx * _backgroundSize.width,
                                top: itemData.offset.dy * _backgroundSize.height,
                                child: DraggableItem(
                                    testData: TestData(text: _scale.toString()),
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
          child: RaisedButton(
            onPressed: () {
              setState(() {
                _scale = 1.0;
              });
            },
            child: Text('Reset'),
          )
        ),
      )
    ]);
  }
}
