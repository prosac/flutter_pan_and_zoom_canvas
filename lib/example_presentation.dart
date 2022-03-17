import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'presentation_container.dart';

class ExamplePresentation extends StatelessWidget {
  final double width = 300;
  final double height = 200;
  final Node node;
  final GlobalKey key = GlobalKey();
  final backgroundSize = Size(4000, 4000); // TODO: should come from the outside
  final VoidCallback onAddPressed;

  Offset get offset {
    return node.offset;
  }

  ExamplePresentation({required this.node, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return PresentationContainer(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${node.toString()}', style: Theme.of(context).textTheme.bodySmall),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildRemoveButton(context),
              NeumorphicButton(
                onPressed: onAddPressed,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.grey.shade200),
                padding: const EdgeInsets.all(20.0),
                child: Icon(Icons.add, color: _iconsColor(context)),
                duration: Duration(milliseconds: 50),
              )
            ]),
          ],
        ));
  }

  NeumorphicButton buildRemoveButton(BuildContext context) {
    GraphModel model = Provider.of<GraphModel>(context, listen: false);

    return NeumorphicButton(
      onPressed: () {
        model.remove(node);
      },
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.grey.shade200),
      padding: const EdgeInsets.all(20.0),
      child: Icon(Icons.delete, color: _iconsColor(context)),
      duration: Duration(milliseconds: 50),
    );
  }

  Color _iconsColor(BuildContext context) {
    return Colors.grey.shade400;
  }
}
