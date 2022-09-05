import 'package:flutter/widgets.dart';

class DraggingProcedureUtilityFunctions {
  static Offset offsetAdaptedToViewParameters(
      Offset offset, double elacs, Offset interactiveViewerOffset) {
    return offset.scale(elacs, elacs).translate(
        -interactiveViewerOffset.dx * elacs,
        -interactiveViewerOffset.dy * elacs);
  }
}
