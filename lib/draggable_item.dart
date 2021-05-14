import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/node_graph_model/connections_model.dart';
import 'package:flutter_pan_and_zoom/item.dart';
import 'package:provider/provider.dart';

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
  })  : assert(scale != null),
        assert(item != null),
        assert(offset != null),
        super(key: key);

  final double scale;
  final Item item;
  final bool isDragging;
  final VoidCallback onDragStarted;
  final DragEndCallback onDragEnd;
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
                final RenderBox renderObject = context.findRenderObject() as RenderBox;
                return renderObject.globalToLocal(position).scale(scale, scale);
              },
              feedback: SizedBox(width: item.width * scale, height: item.height * scale, child: item.presentation),
              onDragStarted: onDragStarted,
              onDragEnd: onDragEnd,
              child: SizedBox(width: item.width, height: item.height, child: item.presentation),
            ),
            Positioned(
              top: 20.0,
              left: 20.0,
              child: NeumorphicButton(
                onPressed: () {
                  var connections = context.read<ConnectionsModel>();
                  connections.startDrawing(this);
                },
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.red.shade300),
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ));
  }
}
