import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:test/test.dart';

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

  group('ticker', () {
    test('is a Ticker', () {
      expect(state.ticker, isA<Ticker>());
    });
    test('initially is not ticking', () {
      expect(state.ticker.isTicking, false);
    });

    test('initially is not active', () {
      expect(state.ticker.isActive, false);
    });
  });

  group('drag(Node node)', () {
    late Node node;
    late BasePresentation presentation;

    setUp(() {
      node = Node.random();
      presentation = ExamplePresentation(node: node, onAddPressed: () {});
      node.presentation = presentation;
    });

    // TODO: now i sense that the node itself should not know its position, but only the presentation!
    test('starts updating of node offset on tick', () {
      // TODO: how to force the presentation to be painted, so a renderBox can be retrieved?
      // expect(state.ticker.isTicking, false);
      // state.drag(node);
      // expect(state.ticker.isTicking, true);
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
