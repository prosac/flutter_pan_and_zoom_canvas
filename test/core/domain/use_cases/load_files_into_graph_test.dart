import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/load_files_into_graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import '../../../helpers/test_helper.mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockFilesRepository mockFilesRepository;
  late UseCase loadFilesIntoGraph;
  late Graph graph;

  setUp(() {
    mockFilesRepository = MockFilesRepository();
    // Sandi Metz rule for command: assert direct public side effect
    // Therefore not mocking the Graph here
    graph = Graph();
    loadFilesIntoGraph = LoadFilesIntoGraph(mockFilesRepository, graph);
  });

  const contents = 'some blabla';
  List<PlainTextFile> files = [PlainTextFile(contents)];

  test(
    'call() - loads files using the repo, adds nodes representing them to the graph',
    () async {
      when(mockFilesRepository.allFiles()).thenAnswer((_) async => Right<Failure, List<PlainTextFile>>(files));

      final result = await loadFilesIntoGraph(NoParams());

      Graph resultGraph = result.fold((exception) => throw exception, (graph) => graph);

      expect(result, Right<Failure, Graph>(graph));
      expect(resultGraph.nodes.length, 1);
      expect(resultGraph.nodes[0].data!.contents, 'some blabla'); // for now naively using PlainTextFile
      verify(mockFilesRepository.allFiles());
      verifyNoMoreInteractions(mockFilesRepository);
    },
  );
}
