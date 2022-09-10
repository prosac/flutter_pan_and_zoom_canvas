import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TestUtils testUtils;

  setUp((() {
    testUtils = TestUtils();
  }));

  group('.start() and .stop()', () {
    testWidgets('starts the dragging procedure', (tester) async {
      var testWidget = MyTestWidget(testUtils.notifier);
      await tester.pumpWidget(testWidget);
      testWidget.start();
      await tester.pump(Duration(milliseconds: 10));
      testWidget.stop();
    });
  });
}

class MyTestWidget extends StatelessWidget {
  final Function notifier;
  late final DraggingProcedure draggingProcedure;
  late final Node node;

  MyTestWidget(this.notifier) {
    node = Node.random();
    node.presentation = BasePresentation(node: node, onAddPressed: () {});
    draggingProcedure = DraggingProcedure(notifier: notifier);
  }

  void start() {
    draggingProcedure.start(node, 1.0, Offset.zero);
  }

  void stop() {
    draggingProcedure.stop();
  }

  @override
  Widget build(BuildContext context) {
    return node.presentation;
  }
}

class TestUtils {
  int notifierCalled = 0;
  void notifier() {
    notifierCalled += 1;
  }
}
