import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'example_content_2.dart';
import 'test_data.dart';

class DraggableItem extends StatelessWidget {
  DraggableItem({
    Key key,
    this.scale,
    this.isDragging = false,
    this.onDragStarted,
    this.onDragEnd,
    this.testData,
    this.offset
  })  : assert(testData != null),
        super(key: key);

  final double scale;
  final TestData testData;
  final bool isDragging;
  final VoidCallback onDragStarted;
  final DragEndCallback onDragEnd;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
        child: Draggable(
          dragAnchorStrategy: (widget, context, position) {
            final RenderBox renderObject = context.findRenderObject() as RenderBox;
            return renderObject.globalToLocal(position).scale(scale, scale);
          },
          data: testData,
          feedback: SizedBox(width: 100 * scale, height: 100 * scale, child: ExampleContent2(label: 'bla', itemColor: Colors.deepPurple)),
          onDragStarted: onDragStarted,
          onDragEnd: onDragEnd,
          child: SizedBox(width: 100, height: 100, child: ExampleContent2(label: 'blub', itemColor: Colors.deepPurpleAccent)),
        )
    );
  }
}
