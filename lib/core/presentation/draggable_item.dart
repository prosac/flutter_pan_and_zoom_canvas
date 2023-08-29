import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/core/presentation/example_presentation.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

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
    super.key,
    required this.scale,
    this.isDragging = false,
    required this.onDragStarted,
    this.onDragEnd,
    this.onDragUpdate,
    this.onDragCompleted,
    required this.node,
    required this.offset,
  });

  final double scale;
  final Node node;
  final bool isDragging;
  final VoidCallback onDragStarted;
  final DragEndCallback? onDragEnd;
  final DragUpdateCallback? onDragUpdate;
  final VoidCallback? onDragCompleted;
  final Offset offset;

  var draggingProcedure;
  var onTick = (Node node, double scale, Offset interactiveViewerOffset) {};
  Ticker ticker = Ticker((_) => {});

  Offset currentOffset() {
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    var feedback = ExamplePresentation(node: node);
    var child = ExamplePresentation(node: node);
    var draggingProcedure = DraggingProcedure();

    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Stack(
          children: [
            Draggable(
                data: node.payload,
                dragAnchorStrategy: (widget, context, offset) {
                  final RenderBox renderObject = context.findRenderObject() as RenderBox;
                  return renderObject.globalToLocal(offset).scale(scale, scale);
                },
                feedback: SizedBox(width: node.width * scale, height: node.height * scale, child: feedback),
                onDragStarted: () {
                  onDragStarted();

                  onTick = (Node node, double scale, Offset interactiveViewerOffset) {
                    if (feedback.key.currentContext == null) {
                      return;
                    }

                    var renderBoxOfNode = feedback.key.currentContext?.findRenderObject() as RenderBox;
                    var nodeOffset = renderBoxOfNode.localToGlobal(Offset.zero);

                    var offset = DraggingProcedureUtilityFunctions.offsetAdaptedToViewParameters(
                        nodeOffset, scale, interactiveViewerOffset);

                    node.offset = offset;
                  };

                  var elacs = pow(scale, -1).toDouble();
                  draggingProcedure.start(node, elacs, onTick);
                },
                onDragEnd: (DraggableDetails details) {
                  draggingProcedure.stop();
                },
                onDragUpdate: onDragUpdate,
                onDragCompleted: () {
                  draggingProcedure.stop();
                },
                child: SizedBox(width: node.width, height: node.height, child: child)),
          ],
        ));
  }
}
