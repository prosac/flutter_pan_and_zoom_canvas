import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

class DraggingProcedure {
  late Function notifier;

  late Ticker ticker;
  late final Node node;
  late final double scale;
  late final Offset interactiveViewerOffset;

  DraggingProcedure({
    required this.notifier,
  });

  void start(node, scale, interactiveViewerOffset) {
    ticker = Ticker((_) {
      var renderBoxOfNode =
          node.presentation.key.currentContext?.findRenderObject() as RenderBox;
      var nodeOffset = renderBoxOfNode.localToGlobal(Offset.zero);

      node.offset =
          DraggingProcedureUtilityFunctions.offsetAdaptedToViewParameters(
              nodeOffset, scale, interactiveViewerOffset);

      notifier();
    });

    ticker.start();
  }

  void stop() {
    ticker.stop();
    ticker = Ticker((_) => {});
  }
}
