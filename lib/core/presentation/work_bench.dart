import 'package:flutter/material.dart';
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
import 'package:flutter_pan_and_zoom/core/presentation/node_with_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_connection_painter.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
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
    print('workbench build');
    final viewerState = get<ViewerState>();
    final mediaQueryData = MediaQuery.of(context);
    Widget? maximizedThing;

    viewerState.parametersFromMatrix(transformationController.value);
    final nodes = watchOnly((Graph g) => g.nodes);
    final edges = watchOnly((Graph g) => g.edges);

    if (viewerState.maximizedThing != null) {
      maximizedThing = viewerState.maximizedThing;
    } else {
      var draggableItems = nodes.map((Node rawNode) {
        var node = NodeWithPresentation(node: rawNode); // TODO: make final?
        node.presentation = ExamplePresentation(node: node);

        return DraggableItem(
            // key: UniqueKey(),
            offset: node.offset,
            scale: viewerState.scale,
            node: node,
            onDragStarted: () {
              print('onDragStarted');
              viewerState.drag(node);
            },
            onDragEnd: (details) {
              // simply dropped
              print('onDragEnd');
              viewerState.stopDragging();
              print('graph.nodes');
              for (Node n in nodes) {
                print(Offset(n.dx, n.dy));
              }
            },
            onDragCompleted: () {
              // NOTE: dropped and accepted by target
              // which is not the case in the current state of things
              print('onDragCompleted');
            });
      }).toList();

      // TODO: unused atm
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

      // TODO: why again two nested Stacks???
      maximizedThing = Stack(children: [
        Stack(
          children: [
            Desktop(
              dragTargetKey: dragTargetKey,
              width: width,
              height: height,
              transformationController: transformationController,
              children: [...draggableItems], // ...visualConnections,
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
    }

    return KeyboardListener(
      focusNode: viewerState.focusNode,
      autofocus: true,
      onKeyEvent: (event) => handleKeyboardOnKey(event),
      child: Container(child: maximizedThing),
    );
  }

  // TODO: unused...
  void centerView() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
  }

  // TODO: dose get<>ing the use cases here count as "within the build method?"
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
