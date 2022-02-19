import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import "item.dart";

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
    required this.item,
    required this.offset,
  }) : super(key: key);

  final double scale;
  final Item item;
  final bool isDragging;
  final VoidCallback? onDragStarted;
  final DragEndCallback? onDragEnd;
  final DragUpdateCallback? onDragUpdate;
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
              data: item.payload,
              dragAnchorStrategy: (widget, context, position) {
                final RenderBox renderObject =
                    context.findRenderObject() as RenderBox;
                return renderObject.globalToLocal(position).scale(scale, scale);
              },
              feedback: SizedBox(
                  width: item.width * scale,
                  height: item.height * scale,
                  child: item.presentation),
              onDragStarted: onDragStarted,
              onDragEnd: onDragEnd,
              onDragUpdate: onDragUpdate,
              child: SizedBox(
                  width: item.width,
                  height: item.height,
                  child: item.presentation),
            ),
            // Positioned(
            //   top: 20.0,
            //   left: 20.0,
            //   child: NeumorphicButton(
            //     onPressed: () {
            //       // var connections = context.read<ConnectionsModel>();
            //       // connections.startDrawing(this);
            //     },
            //     style: NeumorphicStyle(
            //         shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.red.shade300),
            //     padding: const EdgeInsets.all(5.0),
            //     child: Icon(
            //       Icons.add,
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}
