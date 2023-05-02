import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool onTickCalled = false;
  bool notifierCalled = false;

  onTick(node, scale, interactiveViewerOffset) => onTickCalled = true;
  notifier() => notifierCalled = true;

  group('.start() and .stop()', () {
    testWidgets(
        'starts the dragging procedure, calls onTick callback and notifier',
        (tester) async {
      expect(onTickCalled, false);
      expect(notifierCalled, false);
      var testWidget = MyTestWidget(notifier, onTick);
      await tester.pumpWidget(testWidget);
      testWidget.start();
      await tester.pump(Duration(milliseconds: 10));
      testWidget.stop();
      expect(onTickCalled, true);
      expect(notifierCalled, true);
    });
  });
}

class MyTestWidget extends StatelessWidget {
  final Function notifier;
  final Function onTick;
  late final DraggingProcedure draggingProcedure;
  late final Node node;

  MyTestWidget(this.notifier, this.onTick) {
    node = Node.random();
    node.presentation = BasePresentation(node: node);
    draggingProcedure = DraggingProcedure(notifier: notifier);
  }

  void start() {
    draggingProcedure.start(node, 1.0, Offset.zero, onTick);
  }

  void stop() {
    draggingProcedure.stop();
  }

  @override
  Widget build(BuildContext context) {
    return node.presentation;
  }
}
