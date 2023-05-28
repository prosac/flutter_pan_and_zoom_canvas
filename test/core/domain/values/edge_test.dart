import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:test/test.dart';

void main() {
  late Edge edge;
  late Node node1;
  late Node node2;

  setUp(() async {
    node1 = Node();
    node2 = Node();
    edge = Edge(source: node1, destination: node2);
  });

  test('An Edge knows two nodes', () {
    expect(edge.source, node1);
    expect(edge.destination, node2);
  });

  test('An Edge is connected to both of its nodes', () {
    expect(edge.isConnectedTo(node1), true);
    expect(edge.isConnectedTo(node2), true);
  });

  test('an edge conntecting two nodes is equal to another edge connecting the same nodes, making it a value', () {
    var edge2 = Edge(source: node1, destination: node2);
    expect(edge == edge2, true);
  });
}
