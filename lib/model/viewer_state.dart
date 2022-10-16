import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  double elacs = pow(1.0, -1).toDouble();
  bool spaceCommandModeActive = false;
  late DraggingProcedure draggingProcedure;

  var onTick = (Node node, double scale, Offset interactiveViewerOffset) {
    var renderBoxOfNode =
        node.presentation.key.currentContext?.findRenderObject() as RenderBox;
    var nodeOffset = renderBoxOfNode.localToGlobal(Offset.zero);

    node.offset =
        DraggingProcedureUtilityFunctions.offsetAdaptedToViewParameters(
            nodeOffset, scale, interactiveViewerOffset);
  };

  ViewerState({draggingProcedure}) {
    draggingProcedure = DraggingProcedure(notifier: notifyListeners);
  }

  void drag(Node node) {
    elacs = pow(scale, -1).toDouble();
    draggingProcedure = DraggingProcedure(notifier: notifyListeners);
    draggingProcedure.start(node, elacs, interactiveViewerOffset, onTick);
  }

  void parametersFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
    scale = matrix.row0[0];
  }

  void stopDragging() => draggingProcedure.stop();

  void enterSpaceCommandMode() {
    spaceCommandModeActive = true;
    notifyListeners();
  }

  void exitSpaceCommandMode() {
    spaceCommandModeActive = false;
    notifyListeners();
  }

  void resetScale() {
    scale = 1.0;
    notifyListeners();
  }
}
