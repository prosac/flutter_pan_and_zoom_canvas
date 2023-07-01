import 'package:flutter/material.dart';
import 'core/presentation/work_bench.dart';
import 'injection_container.dart' as injectionContainer;
import 'package:flutter_pan_and_zoom/core/presentation/color_theme.dart';

// TODO this feels like way too much down the tree, but maybe for holding the overall state of the graph it is needed like this. Let's see later what we can optimize.
//   WidgetsFlutterBinding.ensureInitialized();
void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // needed?
  await injectionContainer.init();
  runApp(PanAndZoom());
}

class PanAndZoom extends StatelessWidget {
  final Widget home = WorkBench(width: 5000, height: 4000);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pan and Zoom',
      themeMode: ThemeMode.system,
      home: home,
      theme: myTheme,
    );
  }
}
