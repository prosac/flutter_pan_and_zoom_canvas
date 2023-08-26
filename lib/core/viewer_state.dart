import 'dart:math' show pow;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/core/presentation/node_with_presentation.dart';

class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  double elacs = pow(1.0, -1).toDouble();
  bool spaceCommandModeActive = false;
  bool spaceCommandModeDisabled = false;
  FocusNode focusNode;
  Widget? maximizedThing = null;
  Ticker ticker = Ticker((_) => {});

  var onTick = (double scale, Offset interactiveViewerOffset) {};

  NodeWithPresentation? nodeBeingDragged;

  ViewerState({required this.focusNode}) {
    onTick = (double scale, Offset interactiveViewerOffset) {
      if (nodeBeingDragged?.presentation.key.currentContext == null) {
        return;
      }

      var renderBoxOfNode = nodeBeingDragged?.presentation.key.currentContext?.findRenderObject() as RenderBox;
      var nodeOffset = renderBoxOfNode.localToGlobal(Offset.zero);

      nodeBeingDragged?.offset =
          DraggingProcedureUtilityFunctions.offsetAdaptedToViewParameters(nodeOffset, scale, interactiveViewerOffset);
    };
  }

  get somethingMaximized => maximizedThing != null;

  void maximize(Widget widget) {
    maximizedThing = widget;
    notifyListeners();
  }

  void unmaximize() {
    maximizedThing = null;
    notifyListeners();
  }

  void drag(NodeWithPresentation node) {
    nodeBeingDragged = node;

    if (nodeBeingDragged == null) return; // TODO: how to handle potential null elegantly?

    elacs = pow(scale, -1).toDouble();
    ticker = Ticker((_) {
      onTick(scale, interactiveViewerOffset);
      notifyListeners();
    });

    ticker.start();
    notifyListeners();
  }

  void parametersFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
    scale = matrix.row0[0];
    notifyListeners();
  }

  void stopDragging() {
    ticker.stop();
    ticker = Ticker((_) => {});
    nodeBeingDragged = null;
    notifyListeners();
  }

  void enterSpaceCommandMode() {
    if (spaceCommandModeDisabled == true) return;
    spaceCommandModeActive = true;
    notifyListeners();
  }

  void disableSpaceCommandMode() {
    spaceCommandModeActive = false;
    spaceCommandModeDisabled = true;
    notifyListeners();
  }

  void enableSpaceCommandMode() {
    spaceCommandModeActive = false;
    spaceCommandModeDisabled = false;
    notifyListeners();
  }

  void exitSpaceCommandMode() {
    spaceCommandModeActive = false;
    notifyListeners();
  }

  void resetView() {
    scale = 1.0;
    spaceCommandModeActive = false;
    notifyListeners();
  }

  void requestFocus() {
    focusNode.requestFocus();
  }
}
