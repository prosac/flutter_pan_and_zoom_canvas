import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late ViewerState state = ViewerState();

  group('interactiveViewerOffset', () {
    test('initially is zero', () {
      expect(state.interactiveViewerOffset, Offset.zero);
    });
  });

  group('scale', () {
    test('initially is 1.0', () {
      expect(state.scale, 1.0);
    });
  });

  group('drag(Node node)', () {
    late Node node;
    late MyTestWidget testApp;

    setUp(() {
      node = Node.random();
      testApp = MyTestWidget(node);
    });

    testWidgets('.drag()', (tester) async {
      await tester.pumpWidget(testApp);
      final button = find.text('Push me!');
      expect(button, findsOneWidget);
      await tester.pumpAndSettle();
      // await tester.tap(button);
    });
  });

  group('offsetFromMatrix(Matrix4 matrix)', () {
    test('set the interacriveViewerOffset from a Matrix4', () {
      var matrix = Matrix4.translationValues(123, 321, 0);
      state.offsetFromMatrix(matrix);
      expect(state.interactiveViewerOffset, Offset(123, 321));
    });
  });
}

class MyTestWidget extends StatelessWidget {
  final Node node;
  MyTestWidget(this.node) {
    node.presentation = BasePresentation(node: node, onAddPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Test App',
        home: ChangeNotifierProvider<ViewerState>(
            create: (_) => ViewerState(),
            builder: (context, child) {
              return Column(children: [
                node.presentation,
                TextButton(
                  child: Text('Push me!'),
                  onPressed: (() {
                    Provider.of<ViewerState>(context, listen: false).drag(node);
                    // context.watch<ViewerState>().drag(node);
                  }),
                ),
              ]);
            }));
  }
}
