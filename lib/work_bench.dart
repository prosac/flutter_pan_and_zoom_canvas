import 'package:flutter/material.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'example_content_2.dart';
import 'item.dart';
import 'test_data.dart';

class WorkBench extends StatefulWidget {
  WorkBench({
    Key key,
    this.width,
    this.height
  }) : assert(width != null),
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
  TransformationController _transformationController = TransformationController();

  Size _backgroundSize;
  Background _background;
  double _scale = 1.0;

  void putItemInDraggingState(Item itemData) {
    setState(() => items.remove(itemData));
  }

  // TODO: make faktory method of Item
  Item buildItem(Offset offset) {
    return Item(offset: offset, width: 100, height: 100, payload: TestData(text: 'lala'), presentation: ExampleContent2(label: 'blub', itemColor: Colors.deepPurpleAccent));
  }

  void _onAcceptWithDetails(DragTargetDetails details, Size backgroundSize) {
    final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);

    final Offset offset = Offset(
      localOffset.dx / backgroundSize.width,
      localOffset.dy / backgroundSize.height,
    );

    // this is the item added after dragging
    setState(() => items.add(buildItem(offset)));
  }

  @override
  void initState() {
    super.initState();
    _background = Background(width: widget.width, height: widget.height);
    _backgroundSize = Size(4000, 3000);
    // this is the initially added item
    items.add(buildItem(Offset(0, 0)));
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
              _onAcceptWithDetails(details, _backgroundSize);
            },
            builder: (BuildContext context, List<TestData> candidateData, List rejectedData) {
              return Stack(
                children: <Widget>[
                  _background,
                  ...items.map((Item item) {
                    Offset offset =
                      Offset(item.offset.dx * _backgroundSize.width, item.offset.dy * _backgroundSize.height);

                    return DraggableItem(
                      offset: offset,
                      scale: _scale,
                      item: item,
                      onDragStarted: () {
                        putItemInDraggingState(item);
                      },
                      onDragEnd: (DraggableDetails details) {
                        offset = details.offset;
                      }
                    );
                  }).toList()
                ],
              );
            },
            // onWillAccept: () => true,
          )),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: RaisedButton(
          onPressed: () {
            _transformationController.value = Matrix4.identity();

            setState(() {
              _scale = 1.0;
            });
          },
          child: Text('Reset'),
        )),
      )
    ]);
  }
}
