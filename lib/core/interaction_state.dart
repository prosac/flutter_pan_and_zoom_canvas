import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';

class InteractionState with ChangeNotifier {
  Node? nodeToBeConnected;
  Node? draggingNode; // TODO: or better list like in main?
}
