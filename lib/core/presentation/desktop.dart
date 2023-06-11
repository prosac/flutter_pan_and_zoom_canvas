import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
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
            child: Stack(children: children)));
  }
}
