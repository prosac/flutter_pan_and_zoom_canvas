// Mocks generated by Mockito 5.3.0 from annotations
// in flutter_pan_and_zoom/test/model/viewer_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i4;

import 'package:flutter/scheduler.dart' as _i2;
import 'package:flutter_pan_and_zoom/model/dragging_procedure.dart' as _i5;
import 'package:flutter_pan_and_zoom/model/node.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTicker_0 extends _i1.SmartFake implements _i2.Ticker {
  _FakeTicker_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);

  @override
  String toString({bool? debugIncludeStack = false}) => super.toString();
}

class _FakeNode_1 extends _i1.SmartFake implements _i3.Node {
  _FakeNode_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeOffset_2 extends _i1.SmartFake implements _i4.Offset {
  _FakeOffset_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [DraggingProcedure].
///
/// See the documentation for Mockito's code generation for more information.
class MockDraggingProcedure extends _i1.Mock implements _i5.DraggingProcedure {
  MockDraggingProcedure() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Function get notifier =>
      (super.noSuchMethod(Invocation.getter(#notifier), returnValue: () {})
          as Function);
  @override
  set notifier(Function? _notifier) =>
      super.noSuchMethod(Invocation.setter(#notifier, _notifier),
          returnValueForMissingStub: null);
  @override
  Function get onTick =>
      (super.noSuchMethod(Invocation.getter(#onTick), returnValue: () {})
          as Function);
  @override
  set onTick(Function? _onTick) =>
      super.noSuchMethod(Invocation.setter(#onTick, _onTick),
          returnValueForMissingStub: null);
  @override
  _i2.Ticker get ticker => (super.noSuchMethod(Invocation.getter(#ticker),
          returnValue: _FakeTicker_0(this, Invocation.getter(#ticker)))
      as _i2.Ticker);
  @override
  set ticker(_i2.Ticker? _ticker) =>
      super.noSuchMethod(Invocation.setter(#ticker, _ticker),
          returnValueForMissingStub: null);
  @override
  _i3.Node get node => (super.noSuchMethod(Invocation.getter(#node),
      returnValue: _FakeNode_1(this, Invocation.getter(#node))) as _i3.Node);
  @override
  set node(_i3.Node? _node) =>
      super.noSuchMethod(Invocation.setter(#node, _node),
          returnValueForMissingStub: null);
  @override
  double get scale =>
      (super.noSuchMethod(Invocation.getter(#scale), returnValue: 0.0)
          as double);
  @override
  set scale(double? _scale) =>
      super.noSuchMethod(Invocation.setter(#scale, _scale),
          returnValueForMissingStub: null);
  @override
  _i4.Offset get interactiveViewerOffset => (super.noSuchMethod(
          Invocation.getter(#interactiveViewerOffset),
          returnValue:
              _FakeOffset_2(this, Invocation.getter(#interactiveViewerOffset)))
      as _i4.Offset);
  @override
  set interactiveViewerOffset(_i4.Offset? _interactiveViewerOffset) =>
      super.noSuchMethod(
          Invocation.setter(#interactiveViewerOffset, _interactiveViewerOffset),
          returnValueForMissingStub: null);
  @override
  void start(dynamic node, dynamic scale, dynamic interactiveViewerOffset,
          dynamic onTick) =>
      super.noSuchMethod(
          Invocation.method(
              #start, [node, scale, interactiveViewerOffset, onTick]),
          returnValueForMissingStub: null);
  @override
  void stop() => super.noSuchMethod(Invocation.method(#stop, []),
      returnValueForMissingStub: null);
}
