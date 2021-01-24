import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/item.dart';

import 'item.dart';

class DraggableItem extends StatelessWidget {
  DraggableItem({
    Key key,
    this.scale,
    this.isDragging = false,
    this.onDragStarted,
    this.onDragEnd,
    this.item,
    this.offset,
  }) : assert(scale != null),
       assert(item != null),
       assert(offset != null),
       super(key: key);

  final double scale;
  final Item item;
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
          data: item.payload,
          dragAnchorStrategy: (widget, context, position) {
            final RenderBox renderObject = context.findRenderObject() as RenderBox;
            return renderObject.globalToLocal(position).scale(scale, scale);
          },
          feedback: SizedBox(width: item.width * scale, height: item.height * scale, child: item.presentation),
          onDragStarted: onDragStarted,
          onDragEnd: onDragEnd,
          child: SizedBox(width: item.width, height: item.height, child: item.presentation),
        )
    );
  }
}
