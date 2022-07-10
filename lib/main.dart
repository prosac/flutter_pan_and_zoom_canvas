import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/test_bench.dart';
import 'package:flutter_pan_and_zoom/work_bench.dart';
import 'package:provider/provider.dart';

// TODO this feels like way too much down the tree, but maybe for holding the overall state of the graph it is needed like this. Let's see later what we can optimize.
void main() => runApp(ChangeNotifierProvider(
    create: (context) => GraphModel(), child: PanAndZoom()));

class PanAndZoom extends StatelessWidget {
  Widget home = WorkBench(width: 5000, height: 4000);
  // Widget home = TestBench(width: 1000, height: 1000);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Pan and Zoom', home: home);
  }
}
