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
      final startButton = find.text('Start!');
      final stopButton = find.text('Stop!');
      expect(startButton, findsOneWidget);
      expect(stopButton, findsOneWidget);
      await tester.tap(startButton);
      // // This is the trick to bring it alive!
      await tester.pump(Duration(milliseconds: 10));
      await tester.tap(stopButton);
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
                child: Text('Start!'),
                onPressed: (() {
                  draggingProcedure.start(node, 1.0, Offset.zero);
                }),
              ),
              TextButton(
                child: Text('Stop!'),
                onPressed: (() {
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
