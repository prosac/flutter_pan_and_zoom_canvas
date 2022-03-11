import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:provider/provider.dart';

import 'work_bench.dart';

// TODO this feels like way too much down the tree, but maybe for holding the overall state of the graph it is needed like this. Let's see later what we can optimize.
void main() => runApp(ChangeNotifierProvider(create: (context) => GraphModel(), child: PanAndZoom()));

class PanAndZoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pan and Zoom', home: WorkBench(width: 4000, height: 4000));
  }
}
