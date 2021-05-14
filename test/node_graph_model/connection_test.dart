import 'package:flutter_pan_and_zoom/node_graph_model/connection.dart';
import 'package:test/test.dart';

void main() {
  Connection connection;

  setUp(() async {
    connection = Connection();
  });

  test('is a Connection ;-)', () => expect(connection, isA<Connection>()));
}
