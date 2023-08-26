import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/reset_viewport.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/presentation/command_pallete.dart';
import 'package:flutter_pan_and_zoom/core/presentation/desktop.dart';
import 'package:flutter_pan_and_zoom/core/presentation/draggable_item.dart';
import 'package:flutter_pan_and_zoom/core/presentation/example_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_connection_painter.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../domain/entities/node.dart';

class WorkBench extends StatelessWidget with GetItMixin {
  final double width;
  final double height;
  final transformationController = TransformationController();
  final dragTargetKey = GlobalKey();

  WorkBench({required this.width, required this.height});

  Offset get center => Offset(width / 2, height / 2);

  Widget build(BuildContext context) {
    final viewerState = getIt<ViewerState>();
    final mediaQueryData = MediaQuery.of(context);
    Widget? maximizedThing;
    // NOTE: using watchOnly solves the problem that the scale is not up to date for the draggable after zoom
    final scale = watchOnly((ViewerState m) => m.scale);
    final nodes = watchOnly((Graph g) => g.nodes);
    final edges = watchOnly((Graph g) => g.edges);

    viewerState.parametersFromMatrix(transformationController.value);

    var draggableItems = nodes.map((Node node) {
      return DraggableItem(
          offset: Offset(node.dx, node.dy),
          scale: scale,
          node: node,
          onDragStarted: () {
            var graph = getIt<Graph>();
            // NOTE: The Draggable initiates the dragging, but the DragTarget ends it
            graph.drag(node);
            // viewerState.drag(node);
          });
    }).toList();

    print('edges:');
    print(edges.length);

    var visualConnections = edges.map((Edge edge) {
      Size size1 = Size(edge.source.width, edge.destination.height);
      Size size2 = Size(edge.source.width, edge.destination.height);

      Offset nodeOffset1 = Offset(edge.source.dx, edge.source.dy);
      Offset nodeOffset2 = Offset(edge.destination.dx, edge.destination.dy);

      Offset offset1AdaptedToBackground = nodeOffset1;
      Offset offset2AdaptedToBackground = nodeOffset2;

      Offset offset1 =
          Offset(offset1AdaptedToBackground.dx + size1.width / 2, offset1AdaptedToBackground.dy + size1.height / 2);
      Offset offset2 =
          Offset(offset2AdaptedToBackground.dx + size2.width / 2, offset2AdaptedToBackground.dy + size2.height / 2);

      return CustomPaint(painter: SimpleConnectionPainter(start: offset1, end: offset2));
    }).toList();

    maximizedThing = Stack(children: [
      Stack(
        children: [
          Desktop(
            dragTargetKey: dragTargetKey,
            width: width,
            height: height,
            transformationController: transformationController,
            children: [...visualConnections, ...draggableItems],
          )
        ],
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: () => viewerState.enterSpaceCommandMode(),
            label: Text('Things'),
          ),
        ),
      ),
      CommandPallette(
        mediaQueryData: mediaQueryData,
        center: center,
        transformationController: transformationController,
      )
    ]);

    return KeyboardListener(
      focusNode: viewerState.focusNode,
      autofocus: true,
      onKeyEvent: (event) => handleKeyboardOnKey(event),
      child: Container(child: maximizedThing),
    );
  }

  void handleKeyboardOnKey(KeyEvent event) async {
    var viewerState = get<ViewerState>();
    if (event.logicalKey == LogicalKeyboardKey.space) {
      viewerState.enterSpaceCommandMode();
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      viewerState.exitSpaceCommandMode();
      return;
    }

    if (viewerState.spaceCommandModeActive) {
      if (event.logicalKey == LogicalKeyboardKey.keyN) {
        var useCase = get<CreateNode>();
        await useCase(Params(dx: center.dx, dy: center.dy));
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        var useCase = get<DeleteAllNodes>();
        useCase();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        var useCase = get<DeleteAllNodes>();
        useCase();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        var useCase = get<ResetViewport>();
        useCase();
        return;
      }
    }
  }
}
