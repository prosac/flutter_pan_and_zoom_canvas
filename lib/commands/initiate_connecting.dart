import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:provider/provider.dart';

void initiateConnecting({required Node fromNode, required BuildContext context}) {
  final model = context.read<GraphModel>();
  model.nodeToConnect = fromNode;
}
