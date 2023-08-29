import 'package:flutter/scheduler.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class DraggingProcedure {
  late Function onTick;
  late Ticker ticker;
  late final Node node;
  late final double scale;

  final Graph graph = sl<Graph>();
  final ViewerState viewerState = sl<ViewerState>();

  void start(Node node, double scale, Function onTick) {
    ticker = Ticker((_) {
      onTick(node, scale, viewerState.interactiveViewerOffset);
      graph.notify();
    });

    ticker.start();
  }

  void stop() {
    ticker.stop();
    ticker = Ticker((_) => {});
  }
}
