import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CommandPallette extends StatelessWidget with GetItMixin {
  final MediaQueryData mediaQueryData;
  final Offset center;
  final TransformationController transformationController;

  CommandPallette({
    super.key,
    required this.mediaQueryData,
    required this.center,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    var commands = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: resetViewport,
              child: Text('r → Reset'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () => deleteAllNodes(), child: Text('d → Delete all the things')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                ElevatedButton(onPressed: () => createNode(dx: center.dx, dy: center.dy), child: Text('n → Add thing')),
          )
        ]);

    var innerCommandPallette = Container(
        child: Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 400, padding: const EdgeInsets.all(20), child: commands),
          ],
        )
      ],
    ));

    var visible = watchOnly((ViewerState m) => m.spaceCommandModeActive);

    return Visibility(
        visible: visible,
        child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              width: mediaQueryData.size.width,
              color: Colors.black.withOpacity(0.1),
              child: Align(child: innerCommandPallette, alignment: Alignment.bottomCenter),
            )));
  }

  void resetViewport() {
    centerView();
    // viewerState.resetView();
    get<ViewerState>().resetView();
  }

  // TODO: DRY up
  void centerView() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
  }
}
