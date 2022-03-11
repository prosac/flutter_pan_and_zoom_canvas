import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/factories.dart';
import 'package:provider/provider.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'presentation_container.dart';

class ExamplePresentation extends StatelessWidget {
  final label;
  final double width = 300;
  final double height = 200;
  final Offset offset;
  Node? node;

  ExamplePresentation({Key? key, this.label, required this.offset}) : super(key: key);

  // set node(Node node) => _node = node;

  @override
  Widget build(BuildContext context) {
    return PresentationContainer(
        width: width,
        height: height,
        label: label,
        child: Consumer<GraphModel>(builder: (context, GraphModel model, child) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            NeumorphicButton(
              onPressed: () {
                model.remove(node);
              },
              style: NeumorphicStyle(
                  shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.grey.shade200),
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.delete, color: _iconsColor(context)),
              duration: Duration(milliseconds: 50),
            )
          ]);
        }));
  }

  Color _iconsColor(BuildContext context) {
    return Colors.grey.shade400;
  }
}
