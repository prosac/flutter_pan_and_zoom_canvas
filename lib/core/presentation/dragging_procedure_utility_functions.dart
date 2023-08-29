import 'dart:math';

import 'package:flutter/widgets.dart';

class DraggingProcedureUtilityFunctions {
  static Offset offsetAdaptedToViewParameters(Offset offset, double scale, Offset interactiveViewerOffset) {
    var elacs = pow(scale, -1).toDouble();
    return offset
        .scale(elacs, elacs)
        .translate(-interactiveViewerOffset.dx * elacs, -interactiveViewerOffset.dy * elacs);
  }
}
