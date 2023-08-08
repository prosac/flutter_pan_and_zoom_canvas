import 'dart:math' show pow;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/core/presentation/node_with_presentation.dart';

// NOTE: responsible for scaling fuckup: maybe
// NOTE: responsible for draggable only working once fuckup: maybe
// ... the ticker is not stopped somehow!
// the more items are on the destop and dragged, the more timers run!
// still true?
class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  double elacs = pow(1.0, -1).toDouble();
  bool spaceCommandModeActive = false;
  bool spaceCommandModeDisabled = false;
  // Why again did I introduce the DraggingProcedure as a separate object? Stunt for testability?
  // let's try it without having it as a separate object
  // late DraggingProcedure draggingProcedure;
  FocusNode focusNode;
  Widget? maximizedThing = null;
  Ticker ticker = Ticker((_) => {});

  // TODO: make stricter
  var onTick = (double scale, Offset interactiveViewerOffset) {};

  NodeWithPresentation? nodeBeingDragged;

  // ViewerState({draggingProcedure, required this.focusNode}) {
  //   draggingProcedure = DraggingProcedure(notifier: notifyListeners);
  // }

  ViewerState({required this.focusNode}) {
    onTick = (double scale, Offset interactiveViewerOffset) {
      if (nodeBeingDragged?.presentation.key.currentContext == null) {
        return;
      }

      var renderBoxOfNode = nodeBeingDragged?.presentation.key.currentContext?.findRenderObject() as RenderBox;
      var nodeOffset = renderBoxOfNode.localToGlobal(Offset.zero);

      // print(scale);

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
    // draggingProcedure = DraggingProcedure(notifier: notifyListeners);
    // draggingProcedure.start(node, elacs, interactiveViewerOffset, onTick);
    ticker = Ticker((_) {
      onTick(scale, interactiveViewerOffset);
      notifyListeners();
    });

    ticker.start();
    // print('drag');
    notifyListeners();
  }

  void parametersFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
    scale = matrix.row0[0];
    notifyListeners();
  }

  void stopDragging() {
    // print('stopDragging');
    // draggingProcedure.stop();
    ticker.stop();
    ticker = Ticker((_) => {});
    // print('nodeBeingDragged.offset');
    // print(nodeBeingDragged?.offset);
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
