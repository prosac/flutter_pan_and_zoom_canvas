import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:test/test.dart';

class MockRenderBox extends RenderBox {}

class MockPresentation extends BasePresentation {
  final GlobalKey key = GlobalKey();
  final double width = 50;
  final double height = 50;

  MockPresentation() : super(node: Node.random(), onAddPressed: () {});

  RenderBox get renderBox => MockRenderBox();
  Widget build(BuildContext context) => Container();
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.error}) => '';
}

void main() {
  late Node node;

  group('A Node', () {
    setUp(() async {
      node = Node(offset: Offset.zero, payload: TestData());
    });

    test('is a Node ;-)', () {
      expect(node, isA<Node>());
    });

    test('toString() includes the serial nr and offset', () {
      expect(node.toString(), '0:\n0.0\n0.0');
    });
  });

  group('A Node with presentation', () {
    late BasePresentation presentation;

    setUp(() async {
      node = Node(offset: Offset.zero, payload: TestData());
      presentation = MockPresentation();
      node.presentation = presentation;
    });

    test('delegates width and height to the presentation', () {
      expect(node.width, presentation.width);
      expect(node.height, presentation.height);
    });

    group('.renderBox', () {
      test('returns the RenderBox of the presentation', () {
        expect(node.renderBox, isA<RenderBox>());
      });
    });
  });

  group('factories', () {
    group('random', () {
      setUp(() async {
        node = Node.random();
      });
      test('creates a random node', () {
        expect(node, isA<Node>());
      });
      test('the nodes offset is in bearable bounds', () {
        expect(node.offset.dx, lessThanOrEqualTo(1000));
        expect(node.offset.dy, lessThanOrEqualTo(1000));
      });
    });
  });
}
