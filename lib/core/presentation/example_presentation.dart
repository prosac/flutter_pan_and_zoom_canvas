import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node_from_existing.dart';
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
              // Text('${node.toString()}', style: Theme.of(context).textTheme.bodyLarge),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: buttons.getRange(0, buttons.length ~/ 2).toList()),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: buttons.getRange(buttons.length ~/ 2 + 1, buttons.length).toList()),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [buildButton(() => createNodeFromExisting(node), context)])
            ],
          ));
    } else {
      presentation = FittedBox(
        fit: BoxFit.contain,
        child: ElevatedButton(
          onPressed: () {
            createNodeFromExisting(node);
          },
          child: Center(
            child: Icon(Icons.add, color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return presentation;
  }

  Future<void> createNodeFromExisting(node) async => get<CreateNodeFromExisting>()(Params(node: node));

  List<Widget> buildButtons(BuildContext context) {
    return [buildButton(() => createNodeFromExisting(node), context)];
  }

  Padding buildButton(onPressed, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        // child: Icon(useCase.icon, color: Theme.of(context).cardColor),
        child: Icon(Icons.plus_one, color: Theme.of(context).cardColor),
      ),
    );
  }
}
