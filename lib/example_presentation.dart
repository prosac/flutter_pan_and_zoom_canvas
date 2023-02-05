import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';
import 'model/node.dart';
import 'model/simple_action.dart';
import 'presentation_container.dart';

class ExamplePresentation extends BasePresentation {
  final double width = 300;
  final double height = 200;
  final Node node;

  ExamplePresentation({required this.node}) : super(node: node);

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    presentation = Consumer<ViewerState>(builder: (context, viewerState, child) {
      if (viewerState.scale > 0.5) {
        return PresentationContainer(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${node.toString()}', style: Theme.of(context).textTheme.bodyText1),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: actionButtons(context)),
              ],
            ));
      } else {
        return FittedBox(
          fit: BoxFit.contain,
          child: NeumorphicButton(
            onPressed: node.actions[0], // For now simplyuse the first action as the one being accessible on minimal LOD
            style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
            child: Center(
              child: NeumorphicIcon(Icons.add, style: NeumorphicStyle(color: Colors.grey.shade500)),
            ),
          ),
        );
      }
    });

    return presentation;
  }

  List<NeumorphicButton> actionButtons(BuildContext context) {
    return node.actions.map((action) => buildButton(context, action)).toList();
  }

  NeumorphicButton buildButton(BuildContext context, SimpleAction action) {
    return NeumorphicButton(
      onPressed: () {
        action.call();
      },
      style: NeumorphicStyle(shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle()),
      padding: const EdgeInsets.all(20.0),
      child: NeumorphicIcon(action.icon, style: NeumorphicStyle(color: Colors.grey.shade500)),
      duration: Duration(milliseconds: 50),
    );
  }
}
