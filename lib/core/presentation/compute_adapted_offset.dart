import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';

Offset computeAdaptedOffset(Node node, Offset offset, Size widgetSize) {
  var addition = Offset((node.width + 20) / widgetSize.width, (node.height + 20) / widgetSize.height);

  return offset + addition;
}
