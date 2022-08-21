import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class DraggingProcedure {
  late Ticker ticker;
  late final Node node;
  late final double elacs;
  late final Offset interactiveViewerOffset;
  late final Function notifier;

  void start(node, elacs, interactiveViewerOffset) {
    ticker = Ticker((_) {
      node.offset = node.renderBox
          .localToGlobal(Offset.zero)
          .scale(elacs, elacs)
          .translate(-interactiveViewerOffset.dx * elacs,
              -interactiveViewerOffset.dy * elacs);

      notifier();
    });

    ticker.start();
  }

  void stop() {
    ticker.stop();
    ticker = Ticker((_) => {});
  }
}
