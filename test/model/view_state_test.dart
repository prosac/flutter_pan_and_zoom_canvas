import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:test/test.dart';

void main() {
  late ViewerState state = ViewerState();

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

  group('interactiveViewerState', () {
    test('initially is zero', () {
      expect(state.interactiveViewerOffset, Offset.zero);
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
