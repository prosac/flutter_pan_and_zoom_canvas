// TODO: we are mutating an input here! bad! the node should be decorated to know about action
import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_action.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';

// NOTE: responsible for scaling fuckup: rather no
// NOTE: responsible for draggable only working once fuckup: rather no
// TODO: somehow move this into the widgets build actions
// TODO: refactor completely. this is shit
// List<SimpleAction> buildNodeActions(model, Node node, BuildContext context) {
//   return [
//     SimpleAction(icon: Icons.add, callback: () => addNodeFromExisting(node, context)),
//     SimpleAction(icon: Icons.local_drink, callback: () => initiateConnecting(fromNode: node, context: context)),
//     SimpleAction(icon: Icons.link, callback: () => connect(otherNode: node, context: context)),
//     SimpleAction(icon: Icons.delete, callback: () => model.remove(node)),
//     SimpleAction(
//         icon: Icons.minimize,
//         callback: () {
//           if (viewerState.somethingMaximized) {
//             viewerState.unmaximize();
//           } else {
//             viewerState.maximize(node.presentation);
//           }
//         })
//   ];
// }
