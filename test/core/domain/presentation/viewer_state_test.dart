import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/core/presentation/node_with_presentation.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

@GenerateMocks([DraggingProcedure])
import 'viewer_state_test.mocks.dart';

void main() {
  DraggingProcedure draggingProcedure = MockDraggingProcedure();
  late ViewerState state = ViewerState(draggingProcedure: draggingProcedure, focusNode: FocusNode());

  group('DraggingProcedure instance', () {
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
      late MyTestWidget testApp;

      setUp(() => testApp = MyTestWidget());

      testWidgets('.drag()', (tester) async {
        await tester.pumpWidget(testApp);
        await tester.tap(find.text('Start!'));
        await tester.pump(Duration(milliseconds: 5));
        await tester.tap(find.text('Stop!'));
        await tester.pumpAndSettle();
      });
    });

    group('offsetFromMatrix(Matrix4 matrix)', () {
      test('set the interacriveViewerOffset from a Matrix4', () {
        var matrix = Matrix4.translationValues(123, 321, 0);
        state.parametersFromMatrix(matrix);
        expect(state.interactiveViewerOffset, Offset(123, 321));
      });
    });

    group('resetView()', () {
      test('sets scale to 1.0', () {
        state.scale = 123.123;
        state.resetView();
        expect(state.scale, 1.0);
      });
    });
  });
}

class MyTestWidget extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    var node = NodeWithPresentation(node: Node.random());
    node.presentation = BasePresentation(node: node);

    return MaterialApp(
        title: 'Test App',
        home: Column(children: [
          node.presentation,
          TextButton(
            child: Text('Start!'),
            onPressed: (() {
              var viewerState = get<ViewerState>();
              viewerState.drag(node);
            }),
          ),
          TextButton(
              child: Text('Stop!'),
              onPressed: (() {
                var viewerState = get<ViewerState>();

                viewerState.stopDragging();
              })),
        ]));
  }
}
