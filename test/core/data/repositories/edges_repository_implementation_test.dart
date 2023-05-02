import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/edges_local_data_source.dart';
import 'package:flutter_pan_and_zoom/core/data/models/edge_model.dart';
import 'package:flutter_pan_and_zoom/core/data/models/node_model.dart';
import 'package:flutter_pan_and_zoom/core/data/repositories/edges_repository_implementation.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLocalDataSource extends Mock implements EdgesLocalDataSource {}

void main() {
  EdgesRepositoryImplementation repository;
  MockLocalDataSource mockLocalDataSource;

  group('all', () {
    final node1 = NodeModel(id: 1);
    final node2 = NodeModel(id: 2);
    final edge = EdgeModel(node: node1, otherNode: node2);

    test(
      'returns the list of all edges',
      () async {
        // arrange
        mockLocalDataSource = MockLocalDataSource();
        repository =
            EdgesRepositoryImplementation(localDataSource: mockLocalDataSource);
        when(mockLocalDataSource.all()).thenAnswer((_) async => [edge]);
        // act
        final result = await repository.all();
        // assert
        verify(mockLocalDataSource.all());
        expect(result, equals(Right([edge])));
      },
    );
  });
}
