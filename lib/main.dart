import 'package:flutter/material.dart';

import 'work_bench.dart';

void main() => runApp(PanAndZoom());

class PanAndZoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Pan and Zoom', home: WorkBench(width: 14000, height: 13000));
  }
}
