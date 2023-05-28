import 'package:flutter_pan_and_zoom/core/data/models/node_model.dart';
import 'package:test/test.dart';

void main() {
  group('id', () {
    final node = NodeModel(id: 1, dx: 0, dy: 0);

    test(
      'has an interger id',
      () async {
        // arrange
        expect(node.id, equals(1));
      },
    );
  });
}
