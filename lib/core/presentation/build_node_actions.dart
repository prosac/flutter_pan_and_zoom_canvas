// TODO: we are mutating an input here! bad! the node should be decorated to know about action
import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/initiate_connecting.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_action.dart';
import 'package:flutter_pan_and_zoom/features/things/domain/use_cases/add_node_from_existing.dart';

List<SimpleAction> buildNodeActions(model, Node node, BuildContext context) {
  var viewerState = context.read<ViewerState>();

  return [
    SimpleAction(
        icon: Icons.add, callback: () => addNodeFromExisting(node, context)),
    SimpleAction(
        icon: Icons.local_drink,
        callback: () => initiateConnecting(fromNode: node, context: context)),
    SimpleAction(
        icon: Icons.link,
        callback: () => connect(otherNode: node, context: context)),
    SimpleAction(icon: Icons.delete, callback: () => model.remove(node)),
    SimpleAction(
        icon: Icons.minimize,
        callback: () {
          if (viewerState.somethingMaximized) {
            viewerState.unmaximize();
          } else {
            viewerState.maximize(node.presentation);
          }
        })
  ];
}
