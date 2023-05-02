import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEdgesRepository extends Mock implements EdgesRepository {}

void main() {
  Connect usecase;
  MockEdgesRepository mockEdgesRepository;

  setUp(() {
    mockEdgesRepository = MockEdgesRepository();
    usecase = Connect(mockEdgesRepository);
  });

  final node1 = Node.random();
  final node2 = Node.random();
  final edge = Edge(node1, node2);

  test(
    'Adds an edge connecting two nodes',
    () async {
      // arrange
      when(mockEdgesRepository.create(any))
          .thenAnswer((_) async => Right(edge));
      // act
      final result = await usecase(Params(node: node1, otherNode: node2));
      // assert
      expect(result, Right(edge));
      verify(mockEdgesRepository.create(node: node1, otherNode: node2));
      verifyNoMoreInteractions(mockEdgesRepository);
    },
  );
}
