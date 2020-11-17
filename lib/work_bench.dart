
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
  Text info = Text('sdfsdf');
  final List<ItemData> items = <ItemData>[];
  TransformationController _transformationController = TransformationController();

  Size _backgroundSize;
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
    items.add(ItemData(offset: Offset(0, 0), width: 100, height: 100, testData: TestData()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      // the canvas and ui elements that are fixed to the viewport
      // TODO: the item must keep the size fitting the zoom level when dragging
      // TODO: the item must not jump under the cursor when dragging
      Center(
        child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            constrained: false, // this does the trick to make the "canvas" bigger than the view port
            // maxScale: 10,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {

                  _backgroundSize = Size(4000, 3000);

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
                              .map((ItemData itemData) =>
                              Positioned(
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
          child: Text( 'Some widgets\n fixed on the viewport', style: Theme.of(context).textTheme.bodyText1)
        ),
      )
    ]);
  }
}
