import 'dart:ui';

import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_action.dart';

// TODO: find a better name. this _glues_ the conceptual thing Node together with a presentation in the visual world
class NodeWithPresentation {
  late BasePresentation presentation;
  late List<SimpleAction> actions;
  Node node;

  // TODO: actions should be commands in the form of use cases (interactors)
  NodeWithPresentation({required this.node, this.actions = const []}) {}

  get dx => node.dx;
  get dy => node.dy;

  Offset get offset => Offset(dx, dy);

  set offset(Offset offset) {
    node.dx = offset.dx;
    node.dy = offset.dy;
  }

  get height => presentation.height;
  get width => presentation.width;
  get renderBox => presentation.renderBox;
}
