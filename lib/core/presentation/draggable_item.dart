import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/core/presentation/example_presentation.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

/// Wrapper for an [Item] that wraps it in a [Positioned] [Draggable] to make
/// it grabable, draggable, dropable on the workbench. It exposes the
/// [Draggable] callbacks to enable the client to act on the events. It handles
/// the correct scaling by providing a custom [DragAnchorStrategy].
/// The Draggable data is set to the wrapped Items payload.
// Alternative name ideas:
// DraggingWrapper, DragHandle, DragContainer, Positioner, ItemDragger, Dragger
// What to choose? not decided...
class DraggableItem extends StatelessWidget with GetItMixin {
  DraggableItem({
    super.key,
    required this.node,
  });

  final Node node;

  get offset => node.offset;

  var draggingProcedure;
  var onTick = (Node node, double scale, Offset interactiveViewerOffset) {};
  Ticker ticker = Ticker((_) => {});

  @override
  Widget build(BuildContext context) {
    var feedback = ExamplePresentation(node: node);
    var child = ExamplePresentation(node: node);
    var draggingProcedure = sl<DraggingProcedure>();
    var graph = sl<Graph>();
    var viewerState = sl<ViewerState>();
    final scale = watchOnly((ViewerState m) => m.scale);

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
                  graph.drag(node);
                  viewerState.drag(node);
                  draggingProcedure.start(feedback, node);
                },
                onDragEnd: (_) {
                  draggingProcedure.stop();
                },
                onDragCompleted: () {
                  draggingProcedure.stop();
                },
                child: SizedBox(width: node.width, height: node.height, child: child)),
          ],
        ));
  }
}
