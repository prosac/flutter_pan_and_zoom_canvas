import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/reset_viewport.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class KeyboardEvents {
  void handle(KeyEvent event, Offset center, TransformationController transformationController) async {
    var viewerState = sl<ViewerState>();
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
        await createNode(dx: center.dx, dy: center.dy);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        deleteAllNodes();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        deleteAllNodes();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        resetViewport();
        var matrix = Matrix4.identity();
        matrix.translate(-center.dx, -center.dy);
        transformationController.value = matrix;
        return;
      }
    }
  }
}
