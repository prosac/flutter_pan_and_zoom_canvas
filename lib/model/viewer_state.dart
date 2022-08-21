import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  double elacs = pow(1.0, -1).toDouble();
  // Ticker ticker;
  DraggingProcedure draggingProcedure = DraggingProcedure();

  ViewerState() {
    draggingProcedure.notifier = notifyListeners;
  }

  void drag(Node node) {
    elacs = pow(scale, -1).toDouble();
    draggingProcedure.start(node, elacs, interactiveViewerOffset);
  }

  // Offset scaleAndTranslationAdjustedOffset(node) {
  //   return node.renderBox
  //       .localToGlobal(Offset.zero)
  //       .scale(elacs, elacs)
  //       .translate(-interactiveViewerOffset.dx * elacs,
  //           -interactiveViewerOffset.dy * elacs);
  // }

  void offsetFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
  }

  void stopDragging() {
    // ticker.stop();
    draggingProcedure.stop();
  }
}
