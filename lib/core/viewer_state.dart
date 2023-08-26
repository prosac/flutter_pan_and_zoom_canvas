import 'dart:math' show pow;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';

class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  double elacs = pow(1.0, -1).toDouble();
  bool spaceCommandModeActive = false;
  bool spaceCommandModeDisabled = false;
  FocusNode focusNode;
  Widget? maximizedThing = null;

  Node? nodeBeingDragged;

  ViewerState({required this.focusNode});

  get somethingMaximized => maximizedThing != null;

  void maximize(Widget widget) {
    maximizedThing = widget;
    notifyListeners();
  }

  void unmaximize() {
    maximizedThing = null;
    notifyListeners();
  }

  void drag(Node node) {
    nodeBeingDragged = node;

    if (nodeBeingDragged == null) return; // TODO: how to handle potential null elegantly?

    notifyListeners();
  }

  void parametersFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
    scale = matrix.row0[0];
    notifyListeners();
  }

  void stopDragging() {
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
