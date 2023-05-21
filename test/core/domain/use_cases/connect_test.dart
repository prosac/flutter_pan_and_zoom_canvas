import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/graph_components_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<GraphComponentsRepository>()])
@GenerateNiceMocks([MockSpec<MockInteractionState>()])
import 'connect_test.mocks.dart';

class MockGraphComponentsRepository extends Mock implements GraphComponentsRepository {}

class MockInteractionState extends Mock implements InteractionState {}

void main() {
  Connect connect;
  MockGraphComponentsRepository repository;
  MockInteractionState interactionState;

  final node = Node.random();
  final otherNode = Node.random();
  final edge = Edge(source: node, destination: otherNode);

  test(
    'Adds an edge connecting two nodes',
    () async {
      // arrange
      repository = MockGraphComponentsRepository();
      interactionState = MockInteractionState();
      interactionState.nodeToBeConnected = node;
      connect = Connect(repository, interactionState);
      when(repository.createEdge()).thenAnswer((_) async => Right(edge));
      // act
      final result = await connect(Params(otherNode: otherNode));
      // assert
      expect(result, Right(edge));
      verify(repository.createEdge());
      verifyNoMoreInteractions(repository);
    },
  );
}
