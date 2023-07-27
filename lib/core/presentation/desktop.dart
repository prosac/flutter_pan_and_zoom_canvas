import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/test_data.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Desktop extends StatelessWidget with GetItMixin {
  final TransformationController transformationController;
  final double height;
  final double width;
  final GlobalKey dragTargetKey;
  final List<Widget> children;

  Desktop({
    super.key,
    required this.transformationController,
    required this.width,
    required this.height,
    required this.dragTargetKey,
    required this.children,
  });

  RenderBox get dragTargetRenderBox => dragTargetKey.currentContext!.findRenderObject() as RenderBox;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        maxScale: 10.0,
        minScale: 0.01,
        boundaryMargin: EdgeInsets.all(1000.0),
        transformationController: transformationController,
        onInteractionEnd: (details) {
          var viewerState = get<ViewerState>();
          viewerState.parametersFromMatrix(transformationController.value);
        },
        constrained: false, // this does the trick to make the "canvas" bigger than the view port
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1)),
            // TODO: here used to be a DragTarget that set the new offset via GraphModel model.leaveDraggingItemAtNewOffset(offset); of the onAcceptWithDetails
            // see https://github.com/prosac/flutter_pan_and_zoom_canvas/blob/main/lib/work_bench.dart#L176-L185
            child: DragTarget(
              key: dragTargetKey,
              onAcceptWithDetails: (DragTargetDetails details) {
                print('onAcceptWithDetails');
                Offset offset = dragTargetRenderBox.globalToLocal(details.offset);
                var graph = get<Graph>();
                // var interactionState = get<InteractionState>();
                // it used to be
                // model.leaveDraggingItemAtNewOffset(offset);
                // ... but the graph must not know about drawing

                var viewerState = get<ViewerState>();

                // TODO: how in the world get rid of all nulls?
                if (viewerState.nodeBeingDragged == null) {
                  return;
                }

                Node node = viewerState.nodeBeingDragged!.node;

                node.dx = offset.dx;
                node.dy = offset.dy;
                graph.addNode(node);
              },
              builder: (BuildContext context, List<TestData?> candidateData, List rejectedData) {
                return Stack(children: children);
              },
            )));
  }
}
