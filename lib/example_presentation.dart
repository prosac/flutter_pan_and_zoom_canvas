import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/factories.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:provider/provider.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'presentation_container.dart';

class ExamplePresentation extends StatelessWidget {
  final label;
  final double width = 300;
  final double height = 200;
  final Offset offset;
  final Node node;
  final GlobalKey key = GlobalKey();

  ExamplePresentation({required this.node, this.label, required this.offset});

  // set node(Node node) => _node = node;

  @override
  Widget build(BuildContext context) {
    return PresentationContainer(
        width: width,
        height: height,
        label: label,
        child: Consumer<GraphModel>(builder: (context, GraphModel model, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${node.toString()}', style: Theme.of(context).textTheme.bodySmall),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                NeumorphicButton(
                  onPressed: () {
                    model.remove(node);
                  },
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.grey.shade200),
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(Icons.delete, color: _iconsColor(context)),
                  duration: Duration(milliseconds: 50),
                ),
                NeumorphicButton(
                  onPressed: () {
                    var newNodeOffset = _newOffset(node.offset, Size(4000, 4000));

                    model.addFromExistingNode(
                        node, buildNode(newNodeOffset, TestData(text: 'Fancy new node based on another one')));
                  },
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.grey.shade200),
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(Icons.add, color: _iconsColor(context)),
                  duration: Duration(milliseconds: 50),
                )
              ]),
            ],
          );
        }));
  }

  Color _iconsColor(BuildContext context) {
    return Colors.grey.shade400;
  }

  Offset _newOffset(Offset offset, Size backgroundSize) {
    var addition = Offset((width + 20) / backgroundSize.width, (height + 20) / backgroundSize.height);

    return offset + addition;
  }
}
