import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/presentation/command_pallete.dart';
import 'package:flutter_pan_and_zoom/core/presentation/desktop.dart';
import 'package:flutter_pan_and_zoom/core/presentation/draggable_item.dart';
import 'package:flutter_pan_and_zoom/core/presentation/visual_connection.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/keyboard_events.dart';
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
    final viewerState = get<ViewerState>();
    final mediaQueryData = MediaQuery.of(context);
    Widget? maximizedThing;
    // NOTE: using watchOnly solves the problem that the scale is not up to date for the draggable after zoom
    // final scale = watchOnly((ViewerState m) => m.scale);
    final nodes = watchOnly((Graph g) => g.nodes);
    final edges = watchOnly((Graph g) => g.edges);

    viewerState.parametersFromMatrix(transformationController.value);

    if (viewerState.maximizedThing != null) {
      maximizedThing = viewerState.maximizedThing;
    } else {
      var draggableItems = nodes.map((Node node) => DraggableItem(node)).toList();
      var visualConnections = edges.map((Edge edge) => VisualConnection(edge)).toList();

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
    }

    return KeyboardListener(
      focusNode: viewerState.focusNode,
      autofocus: true,
      onKeyEvent: (event) => get<KeyboardEvents>().handle(
          event, center), // TODO: pure laziness. params needed by commands should get in there somehow differently
      child: Container(child: maximizedThing),
    );
  }
}
