import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'presentation_container.dart';

class ExamplePresentation extends StatelessWidget {
  final color;
  final label;
  final double width = 300;
  final double height = 200;
  final Offset offset;

  const ExamplePresentation({Key? key, this.label, this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresentationContainer(
        width: width,
        height: height,
        color: color,
        label: label,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicButton(
              onPressed: () {
                // ... skribbles
                // var connections = context.read<ConnectionsModel>();
                // print(connections.mode());
                // var items = somehowGetTheItemsList();
                // items.add(buildItem(offset, TestData(text: 'Lala')));
              },
              style: NeumorphicStyle(
                  shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.circle(), color: Colors.grey.shade200),
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.delete, color: _iconsColor(context)),
              duration: Duration(milliseconds: 50),
            )
          ],
        ));
  }

  Color _iconsColor(BuildContext context) {
    return Colors.grey.shade400;
  }
}
