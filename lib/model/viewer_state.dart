import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  double elacs = pow(1.0, -1).toDouble();
  late DraggingProcedure draggingProcedure;

  void drag(Node node) {
    elacs = pow(scale, -1).toDouble();
    draggingProcedure = DraggingProcedure(notifier: notifyListeners);
    draggingProcedure.start(node, elacs, interactiveViewerOffset);
  }

  void offsetFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
  }

  void stopDragging() {
    draggingProcedure.stop();
  }
}
