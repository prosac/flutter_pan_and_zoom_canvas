import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:test/test.dart';

void main() {
  late GraphModel model;

  setUp(() async {
    model = GraphModel();
  });

  test('is a Model ;-)', () => expect(model, isA<GraphModel>()));
}
