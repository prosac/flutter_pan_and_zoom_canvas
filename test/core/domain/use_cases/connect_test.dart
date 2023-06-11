import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<Graph>()])
@GenerateNiceMocks([MockSpec<InteractionState>()])
// import 'connect_test.mocks.dart';
import 'connect_test.mocks.dart';

void main() {
  Connect connect;
  MockGraph graph;
  MockInteractionState interactionState;

  final node = Node.random();
  final otherNode = Node.random();
  final edge = Edge(source: node, destination: otherNode);

  test(
    'Adds an edge connecting two nodes',
    () async {
      // arrange
      graph = MockGraph();
      interactionState = MockInteractionState();
      interactionState.nodeToBeConnected = node;
      connect = Connect(graph, interactionState);
      when(graph.addEdge(edge)).thenAnswer((_) async => Right(edge));
      // act
      final result = await connect(Params(otherNode: otherNode));
      // assert
      expect(result, Right(edge));
      verify(graph.addEdge(edge));
      verifyNoMoreInteractions(graph);
    },
  );
}
