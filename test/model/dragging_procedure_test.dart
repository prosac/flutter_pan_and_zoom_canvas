import 'package:flutter/scheduler.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_test/flutter_test.dart';

// I assumme testing the ticker stuff only works when there is actual flutter widget stuff going on
void main() {
  DraggingProcedure draggingProcedure = DraggingProcedure();
  draggingProcedure.notifier = () => {};

  // group('.start(node, elacs, interactiveViewerOffset)', () {
  //   test('it starts a ticker', () {
  //     draggingProcedure.start(Node.random(), 1.0, Offset.zero);
  //     // expect(draggingProcedure.ticker, isA<Ticker>());
  //   });
  // });
}
