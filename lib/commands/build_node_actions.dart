// TODO: we are mutating an input here! bad! the node should be decorated to know about action
import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/commands/add_thing_from_existing.dart';
import 'package:flutter_pan_and_zoom/commands/connect.dart';
import 'package:flutter_pan_and_zoom/commands/initiate_connecting.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/simple_action.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';

List<SimpleAction> buildNodeActions(model, Node node, BuildContext context) {
  var viewerState = context.read<ViewerState>();

  return [
    SimpleAction(icon: Icons.add, callback: () => addThingFromExisting(node, context)),
    SimpleAction(icon: Icons.local_drink, callback: () => initiateConnecting(fromNode: node, context: context)),
    SimpleAction(icon: Icons.link, callback: () => connect(otherNode: node, context: context)),
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
