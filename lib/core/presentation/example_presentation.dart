import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'presentation_container.dart';

class ExamplePresentation extends BasePresentation with GetItMixin {
  final double width = 300;
  final double height = 200;
  final Node node;

  ExamplePresentation({required this.node}) : super(node: node);

  @override
  Widget build(BuildContext context) {
    final scale = watchOnly((ViewerState m) => m.scale);
    Widget presentation;
    if (scale > 0.5) {
      presentation = PresentationContainer(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${node.toString()}', style: Theme.of(context).textTheme.bodyLarge),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: buttons.getRange(0, buttons.length ~/ 2).toList()),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: buttons.getRange(buttons.length ~/ 2 + 1, buttons.length).toList()),
            ],
          ));
    } else {
      presentation = FittedBox(
        fit: BoxFit.contain,
        child: ElevatedButton(
          onPressed: () {},
          child: Center(
            child: Icon(Icons.add, color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return presentation;
  }

  // List<Padding> actionButtons(BuildContext context) {
  //   return node.actions.map((action) => buildButton(context, action)).toList();
  // }

  // Padding buildButton(BuildContext context, SimpleAction action) {
  //   return Padding(
  //     padding: const EdgeInsets.all(4),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         action.call();
  //       },
  //       child: Icon(action.icon, color: Theme.of(context).cardColor),
  //     ),
  //   );
  // }
}
