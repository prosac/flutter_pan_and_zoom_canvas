import 'dart:math';
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class ViewerState with ChangeNotifier {
  Offset interactiveViewerOffset = Offset.zero;
  double scale = 1.0;
  Ticker ticker = Ticker((_) => {});

  void drag(Node node) {
    var renderBoxOfNode =
        node.presentation.key.currentContext?.findRenderObject() as RenderBox;

    var elacs = pow(scale, -1).toDouble();

    ticker = Ticker((_) {
      node.offset = renderBoxOfNode
          .localToGlobal(Offset.zero)
          .scale(elacs, elacs)
          .translate(-interactiveViewerOffset.dx * elacs,
              -interactiveViewerOffset.dy * elacs);

      notifyListeners();
    });

    ticker.start();
  }

  void offsetFromMatrix(Matrix4 matrix) {
    interactiveViewerOffset = Offset(matrix.row0[3], matrix.row1[3]);
  }

  void stopDragging() {
    ticker.stop();
  }
}
