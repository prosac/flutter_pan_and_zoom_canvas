import 'package:flutter/services.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/reset_viewport.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class KeyboardEvents {
  void handle(KeyEvent event, Offset center) async {
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
        var useCase = sl<CreateNode>();
        await useCase(Params(dx: center.dx, dy: center.dy));
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        var useCase = sl<DeleteAllNodes>();
        useCase();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        var useCase = sl<DeleteAllNodes>();
        useCase();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        var useCase = sl<ResetViewport>();
        useCase();
        return;
      }
    }
  }
}
