import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'model/node.dart';

/// Wrapper for an [Item] that wraps it in a [Positioned] [Draggable] to make
/// it grabable, draggable, dropable on the workbench. It exposes the
/// [Draggable] callbacks to enable the client to act on the events. It handles
/// the correct scaling by providing a custom [DragAnchorStrategy].
/// The Draggable data is set to the wrapped Items payload.
// Alternative name ideas:
// DraggingWrapper, DragHandle, DragContainer, Positioner, ItemDragger, Dragger
// What to choose? not decided...
class DraggableItem extends StatelessWidget {
  DraggableItem({
    Key? key,
    required this.scale,
    this.isDragging = false,
    this.onDragStarted,
    this.onDragEnd,
    this.onDragUpdate,
    this.onDragCompleted,
    required this.node,
    required this.offset,
  }) : super(key: key);

  final double scale;
  final Node node;
  final bool isDragging;
  final VoidCallback? onDragStarted;
  final DragEndCallback? onDragEnd;
  final DragUpdateCallback? onDragUpdate;
  final VoidCallback? onDragCompleted;
  final Offset offset;

  Offset currentOffset() {
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Stack(
          children: [
            Draggable(
              data: node.payload,
              dragAnchorStrategy: (widget, context, position) {
                final RenderBox renderObject = context.findRenderObject() as RenderBox;
                return renderObject.globalToLocal(position).scale(scale, scale);
              },
              feedback: SizedBox(width: node.width * scale, height: node.height * scale, child: node.presentation),
              onDragStarted: onDragStarted,
              onDragEnd: onDragEnd,
              onDragUpdate: onDragUpdate,
              onDragCompleted: onDragCompleted,
              child: SizedBox(width: node.width, height: node.height, child: node.presentation),
            ),
          ],
        ));
  }
}
