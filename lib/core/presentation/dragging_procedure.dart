import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';

class DraggingProcedure with ChangeNotifier {
  late Function onTick;
  Ticker ticker = Ticker((_) => {});
  late final Node node;

  final Graph graph;
  final ViewerState viewerState;

  DraggingProcedure({required this.graph, required this.viewerState});

  void start(BasePresentation presentation, Node node) {
    onTick = (Node node) {
      if (presentation.key.currentContext == null) {
        return;
      }

      var renderBoxOfNode = presentation.key.currentContext?.findRenderObject() as RenderBox;
      var nodeOffset = renderBoxOfNode.localToGlobal(Offset.zero);

      var offset = DraggingProcedureUtilityFunctions.offsetAdaptedToViewParameters(
        nodeOffset,
        viewerState.scale,
        viewerState.interactiveViewerOffset,
      );

      node.offset = offset;
    };

    ticker = Ticker((_) {
      onTick(node);
      graph.notify();
    });

    ticker.start();
  }

  void stop() {
    ticker.stop();
    ticker = Ticker((_) => {});
  }
}
