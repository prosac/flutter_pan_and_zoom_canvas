import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/presentation/node_with_presentation.dart';

// Why again did I introduce the DraggingProcedure as a separate object? Stunt for testability?
class DraggingProcedure {
  late Function notifier;
  late Function onTick;

  late Ticker ticker;
  late final NodeWithPresentation node;
  late final double scale;
  late final Offset interactiveViewerOffset;

  DraggingProcedure({
    required this.notifier,
  });

  void start(node, scale, interactiveViewerOffset, onTick) {
    ticker = Ticker((_) {
      onTick(node, scale, interactiveViewerOffset);
      notifier();
    });

    ticker.start();
  }

  void stop() {
    print('DraggingProcedure.stop()');
    ticker.stop();
    ticker = Ticker((_) => {});
  }
}
