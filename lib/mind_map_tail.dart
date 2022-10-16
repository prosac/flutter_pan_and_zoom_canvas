import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'mind_map_tail_path_provider.dart';

class MindMapTail extends StatelessWidget {
  const MindMapTail({super.key});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.path(MindMapTailPathProvider()),
      )
    );
  }
}


