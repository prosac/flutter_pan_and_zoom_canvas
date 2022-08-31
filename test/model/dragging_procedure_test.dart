import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure_utility_functions.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// @GenerateMocks([TestUtils])
@GenerateMocks([DraggingProcedureUtilityFunctions])
void main() {
  late TestUtils testUtils;

  setUp((() {
    testUtils = TestUtils();
  }));

  group('.start() and .stop()', () {
    testWidgets('starts the dragging procedure', (tester) async {
      var testWidget = MyTestWidget(testUtils.notifier);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      final startButton = find.text('Start and stop!');
      expect(startButton, findsOneWidget);
      await tester.tap(startButton);
      await tester.pumpAndSettle();
    });
  });
}

class MyTestWidget extends StatelessWidget {
  final Function notifier;

  MyTestWidget(this.notifier);
  @override
  Widget build(BuildContext context) {
    Node node = Node.random();
    node.presentation = BasePresentation(node: node, onAddPressed: () {});
    DraggingProcedure draggingProcedure = DraggingProcedure(notifier: notifier);

    return MaterialApp(
        title: 'Test App',
        home: SizedBox(
          width: 1000,
          height: 1000,
          child: Column(
            children: [
              node.presentation,
              TextButton(
                child: Text('Start and stop!'),
                onPressed: (() {
                  draggingProcedure.start(node, 1.0, Offset.zero);
                  draggingProcedure.stop();
                }),
              )
            ],
          ),
        ));
  }
}

class TestUtils {
  int notifierCalled = 0;
  void notifier() {
    notifierCalled += 1;
  }
}
