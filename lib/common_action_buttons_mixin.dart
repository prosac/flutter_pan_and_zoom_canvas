import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:provider/provider.dart';

mixin CommonActionButtons on BasePresentation {
  NeumorphicButton buildAddButton(BuildContext context) {
    return NeumorphicButton(
      onPressed: onAddPressed,
      style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
      padding: const EdgeInsets.all(20.0),
      child: NeumorphicIcon(Icons.add,
          style: NeumorphicStyle(color: Colors.grey.shade500)),
    );
  }

  NeumorphicButton buildRemoveButton(BuildContext context) {
    GraphModel model = Provider.of<GraphModel>(context, listen: false);

    return NeumorphicButton(
      onPressed: () {
        model.remove(node);
      },
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle()),
      padding: const EdgeInsets.all(20.0),
      child: NeumorphicIcon(Icons.delete,
          style: NeumorphicStyle(color: Colors.grey.shade500)),
      duration: Duration(milliseconds: 50),
    );
  }
}
