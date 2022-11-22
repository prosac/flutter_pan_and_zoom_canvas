import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/common_action_buttons_mixin.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'presentation_container.dart';

class ExamplePresentation extends BasePresentation with CommonActionButtons {
  final double width = 300;
  final double height = 200;
  final Node node;
  final VoidCallback onAddPressed;

  ExamplePresentation({required this.node, required this.onAddPressed})
      : super(node: node, onAddPressed: onAddPressed);

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    presentation =
        Consumer<ViewerState>(builder: (context, viewerState, child) {
      if (viewerState.scale > 0.5) {
        return PresentationContainer(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${node.toString()}',
                    style: Theme.of(context).textTheme.bodyText1),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildRemoveButton(context),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  buildAddButton(context),
                ]),
              ],
            ));
      } else {
        return FittedBox(
          fit: BoxFit.contain,
          child: NeumorphicButton(
            padding: const EdgeInsets.all(20.0),
            onPressed: onAddPressed,
            style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
            child: Center(
              child: NeumorphicIcon(Icons.add,
                  style: NeumorphicStyle(color: Colors.grey.shade500)),
            ),
          ),
        );
      }
    });

    return presentation;
  }
}
